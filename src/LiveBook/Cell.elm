module LiveBook.Cell exposing (evaluate, evaluateString, view)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input
import Eval
import List.Extra
import Types exposing (Cell, CellState(..), FrontendModel, FrontendMsg(..))
import UILibrary.Button as Button
import UILibrary.Color as Color
import Value exposing (Value)


sourceText : Cell -> List String
sourceText cell =
    cell.text
        |> List.filter (\s -> String.left 1 s /= "#")


evaluateSource : Cell -> Maybe String
evaluateSource cell =
    evaluateString (sourceText cell |> String.join "\n") |> Just


evaluateString : String -> String
evaluateString input =
    case Eval.eval input |> Result.map Value.toString of
        Ok output ->
            output

        Err err ->
            "Error"


{-|

    TODO: Dummy implementation of evaluate : Cell -> Cell

-}
evaluate : Cell -> Cell
evaluate cell =
    { cell | value = evaluateSource cell, cellState = CSView }


view : Int -> String -> Cell -> Element FrontendMsg
view width cellContents cell =
    E.column
        [ E.paddingEach { top = 0, right = 0, bottom = 0, left = 0 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.1 0.1 0.1)
        ]
        [ E.row
            [ E.spacing 12, E.width (E.px width) ]
            [ E.column []
                [ viewSource (width - controlWidth) cell cellContents
                , viewValue (width - controlWidth) cell
                ]
            , E.column
                [ E.spacing 2
                , E.width (E.px controlWidth)
                , E.alignTop
                , E.height E.fill
                , E.paddingEach { top = 0, bottom = 8, left = 0, right = 0 }
                , Background.color (E.rgb 0.3 0.3 0.3)
                ]
                [ viewIndex cell
                , newCellAt cell.cellState cell.index
                , editCellAt cell.cellState cell.index
                , clearCellAt cell.cellState cell.index
                , evalCellAt cell.cellState cell.index
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


viewSource_ : Int -> Cell -> Element msg
viewSource_ width cell =
    E.column
        [ E.spacing 8
        , E.paddingEach { top = 8, right = 0, bottom = 8, left = 8 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.15 0.15 0.15)
        , Font.color (E.rgb 0.9 0.9 0.9)
        ]
        (cell.text |> List.map E.text)


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
            Button.smallPrimary { msg = ClearCell index, status = Button.Active, label = Button.Text "Clear", tooltipText = Just "Edit cell" }


evalCellAt : CellState -> Int -> Element FrontendMsg
evalCellAt cellState index =
    case cellState of
        CSView ->
            Button.smallPrimary { msg = EvalCell index, status = Button.ActiveTransparent, label = Button.Text "Eval", tooltipText = Just "Evaluate cell" }

        CSEdit ->
            Button.smallPrimary { msg = EvalCell index, status = Button.Active, label = Button.Text "Eval", tooltipText = Just "Evaluate cell" }



---
