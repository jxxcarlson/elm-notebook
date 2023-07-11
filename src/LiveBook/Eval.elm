module LiveBook.Eval exposing
    ( evaluateString
    , evaluateStringWithBindings
    , evaluateWithCumulativeBindings
    , evaluateWithCumulativeBindingsCore
    , evaluateWithCumulativeBindingsToResult
    , toListFloatPair
    , transformWordWithValueDict
    , transformWordsWithKVDict
    )

import Dict exposing (Dict)
import Eval
import Eval.Types
import LiveBook.Types exposing (Cell, CellState(..), CellValue(..))
import LiveBook.Utility
import Maybe.Extra
import Value exposing (Value(..))


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


evaluateWithCumulativeBindings : Dict String Value -> Dict String String -> List Cell -> Cell -> Cell
evaluateWithCumulativeBindings valueDict kvDict cells cell =
    let
        ( stringToEvaluate, bindings ) =
            evaluateWithCumulativeBindingsCore valueDict kvDict cells (cell |> Debug.log "@@Cell")
                |> Debug.log "@@(E, B) (2)"

        _ =
            stringToEvaluate |> Debug.log "@@String to evaluate"

        _ =
            bindings |> Debug.log "@@Bindings"
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


evaluateWithCumulativeBindingsCore : Dict String Value -> Dict String String -> List Cell -> Cell -> ( String, List String )
evaluateWithCumulativeBindingsCore valueDict kvDict cells cell =
    let
        exprRecords =
            cells
                |> List.take (cell.index + 1)
                |> List.map getCellExprRecord

        nRecords =
            List.length exprRecords

        bindings : List String
        bindings =
            exprRecords
                |> List.map .bindings
                |> List.map (List.map (transformWordsWithKVDict kvDict))
                |> List.map (List.map (transformWordWithValueDict valueDict))
                |> List.concat

        --|> String.join "\n"
        expressionString_ =
            exprRecords
                |> List.drop (nRecords - 1)
                |> List.map .expression
                |> String.join "\n"
                --|> normalize
                |> String.words
                |> List.map (transformWordsWithKVDict kvDict)
                |> List.map (transformWordWithValueDict valueDict)
                |> String.join " "
                |> Debug.log "@@Expression string_"

        expressionString =
            if expressionString_ == "" then
                "()"

            else
                expressionString_

        bindingString =
            String.join "\n" bindings
    in
    if bindingString == "" then
        ( expressionString, bindings )

    else
        let
            letExpression =
                "let\n"
                    ++ bindingString
                    ++ "\nin\n"
                    ++ expressionString
        in
        ( letExpression, bindings ) |> Debug.log "@@(E, B) (1)"


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
    { bindings : List String, expression : String }


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

        expression =
            List.drop (List.length bindings_) blocks |> List.concat |> String.join "\n"
    in
    { bindings = List.concat bindings_, expression = expression }


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
                Eval.Types.ParsingError deadEnds ->
                    "Parse error"

                Eval.Types.EvalError evalError ->
                    "Evaluation error"


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
