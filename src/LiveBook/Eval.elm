module LiveBook.Eval exposing
    ( evaluate
    , evaluateSource
    , evaluateString
    , evaluateWithCumulativeBindings
    , getCellBindings
    , testCell
    , transformWordsWithKVDict
    )

import Dict exposing (Dict)
import Eval
import List.Extra
import LiveBook.Types exposing (Cell, CellState(..), CellValue(..))
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
                |> Debug.log "@@CELL SOURCE LINES@@"
    in
    if (List.head cellSourceLines |> Maybe.map String.trim) == Just "let" then
        let
            transformedSource =
                List.map (transformWordsWithKVDict kvDict) cellSourceLines |> String.join "\n"
        in
        { cell
            | value =
                evaluateString transformedSource |> Debug.log "@@EVALUATE WITH CUMULATIVE BINDINGS@@" |> CVString
            , cellState = CSView
        }

    else
        let
            bindings =
                getPriorBindings cell.index cells |> Debug.log "@@PRIOR BINDINGS@@"

            lines =
                cell.text
                    |> List.filter (\s -> String.left 1 s /= "#")
                    |> List.filter (\s -> String.trim s /= "")

            n =
                List.length lines

            expression : List String
            expression =
                List.drop (n - 1) lines |> Debug.log "@@EXPRESSION@@"

            isBinding : List String -> Bool
            isBinding list =
                (case list |> List.head |> Maybe.map (String.contains "=") of
                    Just True ->
                        True

                    _ ->
                        False
                )
                    |> Debug.log "@@IS BINDING@@"

            value =
                if bindings == [] then
                    if expression == [] then
                        "()" |> evaluateString |> Debug.log "@@EVAL 1"

                    else
                        expression |> String.join "\n" |> transformWordsWithKVDict kvDict |> evaluateString |> Debug.log "@@EVAL 2"

                else if isBinding expression then
                    "()" |> evaluateString |> Debug.log "@@EVAL 3"

                else if Maybe.map (String.contains "let") (List.Extra.getAt 1 lines) == Just True then
                    "()" |> evaluateString |> Debug.log "@@EVAL 4"

                else if expression == [] then
                    "()" |> evaluateString |> Debug.log "@@EVAL 5"

                else
                    "let"
                        :: (bindings ++ [ "in" ] ++ expression)
                        |> Debug.log "@@EVAL 6:(a)"
                        |> String.join "\n"
                        |> Debug.log "@@EVAL 6:(b)"
                        |> transformWordsWithKVDict kvDict
                        |> Debug.log "@@EVAL 6:(c)"
                        |> evaluateString
                        |> Debug.log "@@EVAL 6"
        in
        { cell | value = CVString value, cellState = CSView }


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



-- BINDINGS


getCellBindings : Cell -> List String
getCellBindings cell =
    let
        lines =
            sourceText_ cell

        firstLine =
            List.head lines |> Maybe.map String.trim |> Maybe.withDefault "---"
    in
    if firstLine == "let" then
        []

    else if String.contains "==" firstLine then
        []

    else if String.contains "=" firstLine then
        let
            n =
                List.length lines

            last =
                List.drop (n - 1) lines |> List.head |> Maybe.withDefault ""
        in
        if Maybe.map (String.contains "let") (List.Extra.getAt 1 lines) == Just True then
            lines

        else if String.contains "=" last then
            lines

        else if String.left 4 (String.trim last) == "else" then
            lines

        else
            List.take (n - 1) lines

    else
        []


getPriorBindings : Int -> List Cell -> List String
getPriorBindings k cells =
    cells
        |> List.take (k + 1)
        |> List.map getCellBindings
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
