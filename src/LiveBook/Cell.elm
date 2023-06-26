module LiveBook.Cell exposing (..)

--( cellList
--, evaluate
--, evaluateString
--, getBindings
--, sourceText
--, toLetInExpression
--, view
--)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events
import Element.Font as Font
import Element.Input
import Eval
import List.Extra
import Types exposing (Cell, CellState(..), FrontendModel, FrontendMsg(..))
import UILibrary.Button as Button
import UILibrary.Color as Color
import Value exposing (Value)
import View.CellThemed as MarkdownThemed
import View.Utility


evaluate : Cell -> Cell
evaluate cell =
    { cell | value = evaluateSource cell, cellState = CSView }


evaluateWithCumulativeBindings : List Cell -> Cell -> Cell
evaluateWithCumulativeBindings cells cell =
    let
        cellSourceLines =
            cell.text
                |> List.filter (\s -> String.left 1 s /= "#")
                |> List.filter (\s -> String.trim s /= "")
    in
    if (List.head cellSourceLines |> Maybe.map String.trim) == Just "let" then
        { cell | value = Just <| evaluateString (cellSourceLines |> String.join "\n"), cellState = CSView }
        --else if List.length cellSourceLines == 1 then
        --    { cell | value = Just <| evaluateString (cellSourceLines |> String.join "\n"), cellState = CSView }

    else
        let
            bindings =
                getBindings cell.index cells

            lines =
                cell.text
                    |> List.filter (\s -> String.left 1 s /= "#")
                    |> List.filter (\s -> String.trim s /= "")

            n =
                List.length lines

            suffix : List String
            suffix =
                List.drop (n - 1) lines

            isBinding : List String -> Bool
            isBinding list =
                case list |> List.head |> Maybe.map (String.contains "=") of
                    Just True ->
                        True

                    _ ->
                        False

            value =
                if bindings == [] then
                    suffix |> String.join "\n" |> evaluateString

                else if isBinding suffix then
                    "()" |> evaluateString

                else
                    "let"
                        :: (bindings ++ [ "in" ] ++ suffix)
                        |> String.join "\n"
                        |> evaluateString
        in
        { cell | value = Just value, cellState = CSView }


evaluateSource : Cell -> Maybe String
evaluateSource cell =
    evaluateString (sourceText cell |> String.join "\n") |> Just


sourceText_ : Cell -> List String
sourceText_ cell =
    cell.text
        |> List.filter (\s -> String.left 1 s /= "#")
        |> List.filter (\s -> String.trim s /= "")


sourceText : Cell -> List String
sourceText cell =
    cell.text
        |> List.filter (\s -> String.left 1 s /= "#")
        |> List.filter (\s -> String.trim s /= "")
        |> toLetInExpression


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
        if String.contains "=" last then
            lines

        else
            List.take (n - 1) lines

    else
        []


getCellBindings1 : Cell -> List String
getCellBindings1 cell =
    let
        lines =
            sourceText_ cell
    in
    if (List.head lines |> Maybe.map String.trim) == Just "let" then
        []

    else
        let
            n =
                List.length lines

            last =
                List.drop (n - 1) lines |> List.head |> Maybe.withDefault ""
        in
        if String.contains "=" last then
            lines

        else
            List.take (n - 1) lines


getBindings : Int -> List Cell -> List String
getBindings k cells =
    cells
        |> List.take (k + 1)
        |> List.map getCellBindings
        |> List.concat


cell1 =
    { index = 0, text = String.lines "a = 1\nb = 5\n(a + b)*(a - b)", value = Nothing, cellState = CSView }


cell2 =
    { index = 1, text = String.lines "c = 11\n(2 * a) + (3 * b) + c", value = Nothing, cellState = CSView }


cellList =
    [ cell1, cell2 ]


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


evaluateString : String -> String
evaluateString input =
    case Eval.eval input |> Result.map Value.toString of
        Ok output ->
            output

        Err err ->
            "Error"


view : Int -> String -> Cell -> Element FrontendMsg
view width cellContents cell =
    E.column
        [ E.paddingEach { top = 0, right = 0, bottom = 0, left = 0 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.1 0.1 0.1)
        ]
        [ E.row
            [ E.width (E.px width) ]
            [ E.column [ E.alignBottom ]
                [ viewSource (width - controlWidth) cell cellContents
                , viewValue (width - controlWidth) cell
                ]
            , E.column
                [ E.spacing 2
                , E.width (E.px controlWidth)
                , E.alignTop
                , E.height E.fill
                , E.paddingEach { top = 0, bottom = 8, left = 4, right = 0 }
                , Background.color Color.darkSteelGray
                ]
                [ viewIndex cell
                , newCellAt cell.cellState cell.index
                , deleteCellAt cell.cellState cell.index

                --, editCellAt cell.cellState cell.index
                , clearCellAt cell.cellState cell.index

                --, evalCellAt cell.cellState cell.index
                ]
            ]
        ]


controlWidth =
    60


viewSource : Int -> Cell -> String -> Element FrontendMsg
viewSource width cell cellContent =
    case cell.cellState of
        CSView ->
            viewSource_ width cell

        CSEdit ->
            editCell width cell cellContent


viewValue width cell =
    E.paragraph
        [ E.spacing 8
        , Font.color Color.black
        , E.paddingEach { top = 8, right = 0, bottom = 12, left = 8 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.85 0.85 0.95)
        ]
        [ E.text (cell.value |> Maybe.withDefault "-- unevaluated --")
        ]


viewIndex : Cell -> Element msg
viewIndex cell =
    E.el [ E.paddingEach { top = 8, bottom = 0, left = 8, right = 0 } ] (E.text <| String.fromInt (cell.index + 1))


viewSource__ : Int -> Cell -> Element FrontendMsg
viewSource__ width cell =
    E.column
        [ E.spacing 8
        , Element.Events.onMouseDown (EditCell cell.index)
        , E.paddingEach { top = 8, right = 0, bottom = 0, left = 8 }
        , E.width (E.px width)
        , E.height E.fill
        , Background.color (E.rgb 0.15 0.15 0.15)
        , Font.color (E.rgb 0.9 0.9 0.9)
        ]
        (cell.text |> List.map E.text)


viewSource_ width cell =
    E.column
        [ E.spacing 8
        , Element.Events.onMouseDown (EditCell cell.index)
        , E.paddingEach { top = 8, right = 0, bottom = 8, left = 0 }
        , E.width (E.px width)
        , Font.size 14
        ]
        [ MarkdownThemed.renderFull (scale 1.0 width)
            (cellHeight cell)
            (cell.text
                |> runMachine
                |> String.join "\n"
            )
        ]


cellHeight : Cell -> Int
cellHeight cell =
    let
        x =
            cell.text |> List.length |> scale 16.5
    in
    if x < 30 then
        (cell.text |> List.length |> scale 16.5) + 35

    else
        (cell.text |> List.length |> scale 16.5) + 55


fixLines : List String -> List String
fixLines lines =
    let
        n =
            List.length lines

        last =
            List.drop (n - 1) lines
    in
    (lines
        |> List.take (n - 1)
        |> List.map fixLine
        |> List.map String.trimRight
    )
        ++ List.map fixLastLine last


type alias State =
    { input : List String
    , output : List String
    , internalState : InternalState
    , lineCount : Int
    , linesOfCode : Int
    , numberOfLines : Int
    }


type InternalState
    = InCode
    | InText


nextState : State -> Step State (List String)
nextState state =
    case List.Extra.getAt 0 state.input of
        Nothing ->
            Done state.output

        Just line ->
            if state.lineCount == state.numberOfLines - 1 then
                case ( state.internalState, String.left 1 line ) of
                    ( InText, "#" ) ->
                        Done (String.dropLeft 2 line :: state.output)

                    ( InText, _ ) ->
                        Done ("```" :: "" :: line :: "```" :: state.output)

                    ( InCode, "#" ) ->
                        Done (String.dropLeft 2 line :: "" :: "```" :: state.output)

                    ( InCode, _ ) ->
                        Done ("```" :: "" :: line :: state.output)

            else
                case ( state.internalState, String.left 1 line ) of
                    ( InText, "#" ) ->
                        Loop
                            -- InText => InText
                            { state
                                | input = List.drop 1 state.input
                                , lineCount = state.lineCount + 1
                                , output =
                                    if List.Extra.getAt 1 state.input == Just "" then
                                        String.dropLeft 2 line :: state.output

                                    else if List.Extra.getAt 1 state.input /= Just "#" then
                                        String.dropLeft 2 line :: state.output

                                    else
                                        (String.dropLeft 2 line ++ " \\") :: state.output
                                , internalState = InText
                            }

                    ( InText, "" ) ->
                        -- InText => InText
                        Loop
                            { state
                                | input = List.drop 1 state.input
                                , lineCount = state.lineCount + 1
                                , output =
                                    if List.Extra.getAt 1 state.input == Just "" then
                                        String.dropLeft 2 line :: state.output

                                    else
                                        String.dropLeft 2 line :: state.output
                                , internalState = InText
                            }

                    ( InText, _ ) ->
                        -- InText => InCode
                        Loop
                            { state
                                | input = List.drop 1 state.input
                                , lineCount = state.lineCount + 1
                                , output = line :: "" :: "```" :: state.output
                                , internalState = InCode
                            }

                    ( InCode, "#" ) ->
                        -- InCode => InText
                        Loop
                            { state
                                | input = List.drop 1 state.input
                                , lineCount = state.lineCount + 1
                                , output =
                                    if List.Extra.getAt 1 state.input == Just "" then
                                        String.dropLeft 2 line :: "" :: "```" :: state.output

                                    else
                                        -- (String.dropLeft 2 line ++ " \\") :: state.output
                                        line :: "" :: "```" :: state.output
                                , internalState = InText
                            }

                    ( InCode, "" ) ->
                        -- InCode => InCode
                        Loop
                            { state
                                | input = List.drop 1 state.input
                                , lineCount = state.lineCount + 1
                                , output =
                                    line :: state.output
                                , internalState = InCode
                            }

                    ( InCode, _ ) ->
                        -- InCode => InCode
                        Loop
                            { state
                                | input = List.drop 1 state.input
                                , lineCount = state.lineCount + 1
                                , output =
                                    if List.Extra.getAt 1 state.input == Just "" then
                                        line :: state.output

                                    else
                                        -- (String.dropLeft 2 line ++ " \\") :: state.output
                                        line :: state.output
                                , internalState = InCode
                            }


runMachine : List String -> List String
runMachine input =
    loop
        { input = input
        , output = []
        , internalState = InText
        , lineCount = 0
        , linesOfCode = 0
        , numberOfLines = List.length input
        }
        nextState
        |> List.reverse


lines0 =
    """# Example: 
1 + 1 == 2""" |> String.lines


lines1 =
    """# AAA
# BBB
a = 1
b = 1
a + b
# Thats' cool!""" |> String.lines


type Step state a
    = Loop state
    | Done a


loop : state -> (state -> Step state a) -> a
loop s nextState_ =
    case nextState_ s of
        Loop s_ ->
            loop s_ nextState_

        Done b ->
            b


fixLastLine : String -> String
fixLastLine line =
    if String.left 1 line == "#" then
        String.replace "#" "" line

    else
        line


fixLine : String -> String
fixLine line =
    if String.left 1 line == "#" then
        String.replace "#" "" line ++ " \\"

    else
        line ++ " \\"


scale : Float -> Int -> Int
scale factor x =
    round <| factor * toFloat x


editCell : Int -> Cell -> String -> Element FrontendMsg
editCell width cell cellContent =
    E.column
        [ E.spacing 8
        , E.paddingEach { top = 1, right = 1, bottom = 1, left = 1 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.1 0.1 0.8)
        ]
        [ Element.Input.multiline
            [ Background.color (E.rgb 0.8 0.8 1.0)
            , Font.color Color.black
            ]
            { onChange = InputElmCode cell.index
            , text = cellContent
            , placeholder = Nothing
            , label = Element.Input.labelHidden ""
            , spellcheck = False
            }
        ]



-- (cell.text |> List.map E.text)


newCellAt : CellState -> Int -> Element FrontendMsg
newCellAt cellState index =
    case cellState of
        CSView ->
            Button.smallPrimary { msg = NewCell index, status = Button.ActiveTransparent, label = Button.Text "New", tooltipText = Just "Insert  new cell" }

        CSEdit ->
            E.none


deleteCellAt : CellState -> Int -> Element FrontendMsg
deleteCellAt cellState index =
    case cellState of
        CSView ->
            Button.smallPrimary { msg = DeleteCell index, status = Button.ActiveTransparent, label = Button.Text "Delete", tooltipText = Just "Insert  new cell" }

        CSEdit ->
            E.none


editCellAt : CellState -> Int -> Element FrontendMsg
editCellAt cellState index =
    case cellState of
        CSView ->
            Button.smallPrimary { msg = EditCell index, status = Button.ActiveTransparent, label = Button.Text "Edit", tooltipText = Just "Edit cell" }

        CSEdit ->
            E.none


clearCellAt : CellState -> Int -> Element FrontendMsg
clearCellAt cellState index =
    case cellState of
        CSView ->
            E.none

        CSEdit ->
            Button.smallPrimary { msg = ClearCell index, status = Button.Active, label = Button.Text "x", tooltipText = Just "Edit cell" }


evalCellAt : CellState -> Int -> Element FrontendMsg
evalCellAt cellState index =
    case cellState of
        CSView ->
            Button.smallPrimary { msg = EvalCell index, status = Button.ActiveTransparent, label = Button.Text "Eval", tooltipText = Just "Evaluate cell" }

        CSEdit ->
            Button.smallPrimary { msg = EvalCell index, status = Button.Active, label = Button.Text "Eval", tooltipText = Just "Evaluate cell" }



---
