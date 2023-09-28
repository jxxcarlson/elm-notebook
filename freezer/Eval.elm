module LiveBook.Eval exposing
    ( evaluateExpressionStringWithState
    , evaluateString
    , evaluateStringWithBindings
    , evaluateWithContext
    , evaluateWithContextCore
    , evaluateWordsWithState
    , getPriorBindings
    , toListFloatPair
    , transformWordWithValueDict
    , transformWordsWithKVDict
    )

import Dict exposing (Dict)
import Eval
import Eval.Types
import List.Extra
import LiveBook.State
import LiveBook.Types exposing (Cell, CellState(..), CellValue(..))
import LiveBook.Utility
import Maybe.Extra
import Parser exposing (Problem(..))
import Value exposing (EvalErrorKind(..), Value(..))


evaluate : Cell -> Cell
evaluate cell =
    { cell
        | value =
            case evaluateSource cell of
                Nothing ->
                    CVNone

                Just str ->
                    CVString str
        , cellState = CSView
    }


evaluateWithContext : LiveBook.State.MState -> Dict String Value -> Dict String String -> List Cell -> Cell -> Cell
evaluateWithContext state valueDict kvDict cells cell =
    let
        ( stringToEvaluate, bindings ) =
            evaluateWithContextCore state valueDict kvDict cells cell
    in
    if stringToEvaluate == "()" then
        { cell | value = CVNone, cellState = CSView }

    else
        { cell
            | value = CVString (evaluateString stringToEvaluate)
            , bindings = bindings
            , expression = stringToEvaluate
            , cellState = CSView
        }


evaluateWithContextCore : LiveBook.State.MState -> Dict String Value -> Dict String String -> List Cell -> Cell -> ( String, List String )
evaluateWithContextCore state valueDict kvDict cells cell =
    let
        exprRecords =
            cells
                |> List.map getCellExprRecord

        nRecords =
            List.length exprRecords

        bindings : List String
        bindings =
            exprRecords
                |> List.map .bindings
                |> List.map (List.map (transformWordsWithKVDict kvDict))
                |> List.map (List.map (transformWordWithValueDict valueDict))
                |> List.map (List.map (evaluateWordsWithState state))
                |> List.concat

        expressionStrings__ : List String
        expressionStrings__ =
            getCellExprRecord cell
                |> .expressions

        processExpressionString : String -> String
        processExpressionString str =
            str
                --|> normalize
                |> String.words
                |> List.map (transformWordsWithKVDict kvDict)
                |> List.map (transformWordWithValueDict valueDict)
                |> List.map (evaluateWordsWithState state)
                |> String.join " "
                |> (\str_ ->
                        if str_ == "" then
                            "()"

                        else
                            str_
                   )

        expressionStrings =
            List.map processExpressionString expressionStrings__

        expressionString =
            case expressionStrings of
                [] ->
                    "()"

                [ str ] ->
                    str

                _ ->
                    "[ " ++ (expressionStrings |> String.join ", ") ++ " ]"

        bindingString =
            String.join "\n" bindings
    in
    if expressionString == "state" then
        ( expressionString, [] )

    else if bindingString == "" then
        ( expressionString, bindings )

    else
        let
            letExpression =
                "let\n"
                    ++ bindingString
                    ++ "\nin\n"
                    ++ expressionString
        in
        ( letExpression, bindings )


evaluateWithBindings : Dict String String -> Dict String Value -> List String -> String -> Result Eval.Types.Error Value
evaluateWithBindings kvDict valueDict bindings str =
    let
        stringToEvaluate_ =
            if bindings == [] then
                str

            else
                "let\n"
                    ++ String.join "\n" bindings
                    ++ "\nin\n"
                    ++ str

        stringToEvaluate =
            stringToEvaluate_
                |> String.words
                |> List.map (transformWordsWithKVDict kvDict)
                |> List.map (transformWordWithValueDict valueDict)
                |> String.join " "
    in
    Eval.eval stringToEvaluate


evaluateStringWithBindings : List String -> String -> String
evaluateStringWithBindings bindings str =
    if bindings == [] then
        str |> evaluateString

    else
        "let\n"
            ++ String.join "\n" bindings
            ++ "\nin\n"
            ++ str
            |> evaluateString


compress : String -> String
compress str =
    str
        |> String.replace " , " ","
        |> String.replace " ( " "("
        |> String.replace " ) " ")"
        |> String.replace " [ " "["
        |> String.replace " ] " "]"


evaluateWithCumulativeBindingsToResult : Dict String String -> List Cell -> String -> Result Eval.Types.Error Value
evaluateWithCumulativeBindingsToResult kvDict cells variable =
    let
        exprRecords =
            cells
                |> List.map getCellExprRecord

        bindingString : String
        bindingString =
            exprRecords
                |> List.map .bindings
                |> List.concat
                |> String.join "\n"

        stringToEvaluate =
            if bindingString == "" then
                variable

            else
                "let\n"
                    ++ bindingString
                    ++ "\nin\n"
                    ++ variable
    in
    Eval.eval stringToEvaluate


transformWordsWithKVDict : Dict String String -> String -> String
transformWordsWithKVDict dict str =
    str |> String.words |> List.map (transformWordWithKVDict dict) |> String.join " "


normalize : String -> String
normalize str =
    str
        |> String.replace "," " , "
        |> String.replace "(" " ( "
        |> String.replace ")" " ) "
        |> String.replace "[" " [ "
        |> String.replace "]" " ] "


transformWordWithKVDict : Dict String String -> String -> String
transformWordWithKVDict dict word =
    case Dict.get word dict of
        Nothing ->
            word

        Just substitute ->
            substitute


evaluateWordsWithState : LiveBook.State.MState -> String -> String
evaluateWordsWithState state str =
    str
        |> String.words
        |> List.map (evaluateWordWithState state)
        |> String.join " "


evaluateWordWithState : LiveBook.State.MState -> String -> String
evaluateWordWithState state str =
    str
        |> evaluateWordWithState1 state
        |> evaluateWordWithState2 state


evaluateWordWithState1 : LiveBook.State.MState -> String -> String
evaluateWordWithState1 state str =
    str
        |> String.replace "state.values"
            (state.values
                |> List.map Value.toString
                |> String.join ", "
                |> (\x -> "[ " ++ x ++ " ]")
            )


evaluateWordWithState2 : LiveBook.State.MState -> String -> String
evaluateWordWithState2 state str =
    str
        |> String.replace "state.value" (state.currentValue |> Value.toString)


transformWordWithValueDict : Dict String Value -> String -> String
transformWordWithValueDict dict word =
    let
        _ =
            word
    in
    case Dict.get word dict of
        Nothing ->
            word

        Just substitute ->
            case substitute of
                Float float ->
                    String.fromFloat float

                List list ->
                    substitute
                        |> unwrapListFloat
                        |> Maybe.map listFloatToString
                        |> Maybe.withDefault "[]"

                Tuple (Float float1) (Float float2) ->
                    "(" ++ String.fromFloat float1 ++ ", " ++ String.fromFloat float2 ++ ")"

                _ ->
                    "None"


listFloatToString : List Float -> String
listFloatToString list =
    list
        |> List.map String.fromFloat
        |> String.join ", "
        |> (\str -> "[" ++ str ++ "]")


evaluateSource : Cell -> Maybe String
evaluateSource cell =
    evaluateString (sourceText_ cell |> toLetInExpression |> String.join "\n") |> Just


basicCell : List String -> Cell
basicCell lines =
    { index = 0
    , text = lines
    , bindings = []
    , expression = ""
    , value = CVNone
    , cellState = CSView
    , locked = False
    }


{-|

    > cell1
    { cellState = CSView, index = 0, text = ["> a = 1","> b = 1","","> f n = ","  if n == 0 then 1 else n * f (n - 1)"], value = CVNone }

    > getCellBindings cell1
    ["a = 1","b = 1","f n =","  if n == 0 then 1 else n * f (n - 1)"]

-}
getBlocks : Cell -> List (List String)
getBlocks cell =
    cell
        |> sourceText_
        |> LiveBook.Utility.getChunks


type alias CellExpressionRecord =
    { bindings : List String, expressions : List String }


{-|

    > cell3
    { cellState = CSView, index = 0, text = ["> a = 1","> b = 1","> a + b"], value = CVNone }

    > getCellExprRecord cell3
    { bindings = ["a = 1","b = 1"], expression = "a + b" }

-}
getCellExprRecord : Cell -> CellExpressionRecord
getCellExprRecord cell =
    let
        blocks =
            getBlocks cell

        bindings_ : List (List String)
        bindings_ =
            List.filter (\chunk_ -> isBinding_ chunk_) blocks

        expressions : List (List String)
        expressions =
            List.filter (\chunk_ -> not <| isBinding_ chunk_) blocks
    in
    { bindings = List.concat bindings_, expressions = List.concat expressions }


isBinding_ : List String -> Bool
isBinding_ list =
    case List.head list of
        Just first ->
            List.member "=" (String.words first)

        _ ->
            False


getPriorBindings : Int -> List Cell -> List String
getPriorBindings k cells =
    cells
        |> List.take (k + 1)
        |> List.map (getCellExprRecord >> .bindings)
        |> List.concat


toLetInExpression : List String -> List String
toLetInExpression lines =
    if (List.head lines |> Maybe.map String.trim) == Just "let" then
        lines

    else
        let
            n =
                List.length lines

            letBody =
                List.take (n - 1) lines

            lastLine =
                List.drop (n - 1) lines
        in
        if n < 2 then
            lines

        else
            "let" :: (letBody ++ ("in" :: lastLine))


sourceText_ : Cell -> List String
sourceText_ cell =
    cell.text
        |> List.filter (\s -> String.left 1 s /= "#")
        |> List.filter (\s -> String.trim s /= "")


evaluateString : String -> String
evaluateString input =
    case Eval.eval input |> Result.map Value.toString of
        Ok output ->
            output

        Err err ->
            case err of
                Eval.Types.ParsingError errors ->
                    showParseError input (Eval.Types.ParsingError errors)

                Eval.Types.EvalError evalError ->
                    showEvalError evalError


showParseError source parseError =
    case parseError of
        Eval.Types.ParsingError errors ->
            let
                foo =
                    List.map (.problem >> toString) errors |> String.join "; "

                toString yuk =
                    case yuk of
                        Expecting str ->
                            "Expecting String: \"" ++ str ++ "\""

                        ExpectingInt ->
                            "Expecting Int"

                        ExpectingHex ->
                            "Expecting Hex"

                        ExpectingOctal ->
                            "Expecting Octal"

                        ExpectingBinary ->
                            "Expecting Binary"

                        ExpectingFloat ->
                            "Expecting Float"

                        ExpectingNumber ->
                            "Expecting Number"

                        ExpectingVariable ->
                            "Expecting Variable"

                        ExpectingKeyword str ->
                            "Expecting Keyword: \"" ++ str ++ "\""

                        UnexpectedChar ->
                            "Unexpected Char"

                        Problem str ->
                            "Problem: \"" ++ str ++ "\""

                        BadRepeat ->
                            "Bad Repeat"

                        ExpectingSymbol symbol ->
                            "Expecting symbol: \"" ++ symbol ++ "\""

                        ExpectingEnd ->
                            "Expecting end; there may be a missing parenthesis or some such."
            in
            "Parse error: " ++ foo ++ "::" ++ getErrorText 4 19 source

        _ ->
            "I don't know how to show this error."


getErrorText : Int -> Int -> String -> String
getErrorText row column str =
    str |> String.lines |> List.Extra.getAt (row - 1) |> Maybe.withDefault "" |> String.dropLeft (column - 1)


showEvalError : { a | error : EvalErrorKind } -> String
showEvalError evalError =
    case evalError.error of
        TypeError str ->
            "type error: " ++ str

        _ ->
            "I don't know how to show this EVAL error."


toListFloatPair : Value -> Maybe (List ( Float, Float ))
toListFloatPair value =
    case value of
        List valueList ->
            List.map toFloatPair valueList |> Maybe.Extra.combine

        _ ->
            Nothing


toFloatPair : Value -> Maybe ( Float, Float )
toFloatPair value =
    case value of
        Tuple a b ->
            case ( toFloat_ a, toFloat_ b ) of
                ( Just x, Just y ) ->
                    Just ( x, y )

                _ ->
                    Nothing

        _ ->
            Nothing


toFloat_ : Value -> Maybe Float
toFloat_ value =
    case value of
        Float x ->
            Just x

        _ ->
            Nothing



--type Value
--    = String String
--    | Int Int
--    | Float Float
--    | Char Char
--    | Bool Bool
--    | Unit
--    | Tuple Value Value
--    | Triple Value Value Value
--    | Record (Dict String Value)
--    | Custom QualifiedNameRef (List Value)
--    | PartiallyApplied Env (List Value) (List (Node Pattern)) (Maybe QualifiedNameRef) (Node Expression)
--    | JsArray (Array Value)
--    | List (List Value)


unwrapFloat : Value -> Maybe Float
unwrapFloat value =
    case value of
        Float float ->
            Just float

        _ ->
            Nothing


unwrapListFloat : Value -> Maybe (List Float)
unwrapListFloat value =
    case value of
        List list ->
            List.map unwrapFloat list |> List.filterMap identity |> Just

        _ ->
            Nothing


evaluateExpressionStringWithState state str =
    str
        |> String.words
        |> List.map (evaluateWordsWithState state)
        |> String.join " "
