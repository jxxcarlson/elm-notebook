module LiveBook.Eval exposing
    ( basicCell
    , evaluate
    , evaluateSource
    , evaluateString
    , evaluateWithCumulativeBindings
    , evaluateWithCumulativeBindings_
    , getBlocks
    , getCellBindings
    , getCellExprRecord
    , getPriorBindings
    , isBinding_
    , testCell
    , transformWordsWithKVDict
    )

import Dict exposing (Dict)
import Eval
import List.Extra
import LiveBook.Types exposing (Cell, CellState(..), CellValue(..))
import LiveBook.Utility
import Value exposing (Value)


cText =
    """
factoriaTC n =
    let
        f x acc =
            if x == 0 then
                acc
            else
                f (x - 1) (x * acc)
    in
    f n 1
"""



--{ index : Int, text : List String, value : Maybe String, cellState : CellState }


testCell =
    { index = 0, text = String.lines cText, value = Nothing, cellState = CSView }


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


evaluateWithCumulativeBindings : Dict String String -> List Cell -> Cell -> Cell
evaluateWithCumulativeBindings kvDict cells cell =
    case cell.value of
        CVVisual _ _ ->
            cell

        _ ->
            evaluateWithCumulativeBindings_ kvDict cells cell


evaluateWithCumulativeBindings_ : Dict String String -> List Cell -> Cell -> Cell
evaluateWithCumulativeBindings_ kvDict cells cell =
    let
        cellSourceLines =
            cell.text
                |> List.filter (\s -> String.left 1 s /= "#")
                |> List.filter (\s -> String.trim s /= "")

        exprRecords =
            cells
                |> List.take (cell.index + 1)
                |> List.map getCellExprRecord
                |> Debug.log "@@CELL RECORDS"

        nRecords =
            List.length exprRecords

        bindingString : String
        bindingString =
            exprRecords
                |> List.map .bindings
                |> Debug.log "@@FINAL BINDINGS (1)"
                -- |> List.map (List.map (transformWordsWithKVDict kvDict))
                |> List.concat
                |> Debug.log "@@FINAL BINDINGS (2)"
                |> String.join "\n"
                |> Debug.log "@@BINDING STRING"

        -- expressionString : String
        expressionString =
            exprRecords
                |> List.drop (nRecords - 1)
                |> List.map .expression
                |> String.join "\n"
                |> String.words
                |> List.map (transformWordsWithKVDict kvDict)
                |> String.join " "
                |> Debug.log "@@EXPRESSION STRING"

        stringToEvaluate =
            if bindingString == "" then
                expressionString

            else
                "let\n"
                    ++ bindingString
                    ++ "\nin\n"
                    ++ expressionString
                    |> Debug.log "@@STRING TO EVALUATE"
    in
    { cell | value = CVString (evaluateString stringToEvaluate), cellState = CSView }



--if (List.head cellSourceLines |> Maybe.map String.trim) == Just "let" then
--    let
--        transformedSource =
--            List.map (transformWordsWithKVDict kvDict) cellSourceLines |> String.join "\n"
--    in
--    { cell
--        | value =
--            evaluateString transformedSource |> CVString
--        , cellState = CSView
--    }
--
--else
--    let
--        bindings =
--            getPriorBindings cell.index cells |> Debug.log "@@BINDINGS"
--
--        lines =
--            cell.text
--                |> List.filter (\s -> String.left 1 s /= "#")
--                |> List.filter (\s -> String.trim s /= "")
--
--        n =
--            List.length lines
--
--        expression : List String
--        expression =
--            List.drop (n - 1) lines |> Debug.log "@@EXPRESSIO"
--
--        isBinding : List String -> Bool
--        isBinding list =
--            (case list |> List.head |> Maybe.map (String.contains " = ") of
--                Just True ->
--                    True
--
--                _ ->
--                    False
--            )
--                |> Debug.log "@@ISBINDING"
--
--        value =
--            if bindings == [] then
--                if expression == [] then
--                    "()" |> evaluateString |> Debug.log "@@EV 1"
--
--                else
--                    expression
--                        |> Debug.log "@@EV 2 a"
--                        |> List.map (transformWordsWithKVDict kvDict)
--                        |> Debug.log "@@EV 2 b"
--                        |> String.join "\n"
--                        |> Debug.log "@@EV 2 c"
--                        |> evaluateString
--                        |> Debug.log "@@EV 2 !!"
--
--            else if isBinding expression then
--                "()" |> evaluateString |> Debug.log "@@EV 3"
--
--            else if Maybe.map (String.contains "let") (List.Extra.getAt 1 lines) == Just True then
--                "()" |> evaluateString |> Debug.log "@@EV 4"
--
--            else if expression == [] then
--                "()" |> evaluateString |> Debug.log "@@EV 5"
--
--            else
--                "let"
--                    :: (bindings ++ [ "in" ] ++ expression)
--                    |> List.map (transformWordsWithKVDict kvDict)
--                    |> String.join "\n"
--                    |> evaluateString
--                    |> Debug.log "@@EV 6"
--    in
--    { cell | value = CVString value, cellState = CSView }
--


transformWordsWithKVDict : Dict String String -> String -> String
transformWordsWithKVDict dict str =
    str |> String.words |> List.map (transformWordWithKVDict dict) |> String.join " "


transformWordWithKVDict : Dict String String -> String -> String
transformWordWithKVDict dict word =
    case Dict.get word dict of
        Nothing ->
            word

        Just substitute ->
            substitute


evaluateSource : Cell -> Maybe String
evaluateSource cell =
    evaluateString (sourceText_ cell |> toLetInExpression |> String.join "\n") |> Just



--getCellBindings : Cell -> List String


basicCell : List String -> Cell
basicCell lines =
    { index = 0, text = lines, value = CVNone, cellState = CSView }


{-|

    > cell1
    { cellState = CSView, index = 0, text = ["> a = 1","> b = 1","","> f n = ","  if n == 0 then 1 else n * f (n - 1)"], value = CVNone }

    > getCellBindings cell1
    ["a = 1","b = 1","f n =","  if n == 0 then 1 else n * f (n - 1)"]

-}
getCellBindings : Cell -> List String
getCellBindings cell =
    cell
        |> sourceText_
        |> LiveBook.Utility.getChunks
        |> List.filter (\chunk_ -> isBinding_ chunk_)
        |> List.concat


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
        |> Debug.log "@@GETPRIOR (1)"
        |> List.map (getCellExprRecord >> .bindings)
        |> Debug.log "@@GETPRIOR (2)"
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
            "Error"
