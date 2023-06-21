module LiveBook.Cell exposing (evaluate, view)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Font
import Element.Input
import List.Extra
import LiveBook.Types exposing (Cell, CellState(..))
import Types exposing (FrontendModel, FrontendMsg(..))
import UILibrary.Button as Button
import UILibrary.Color as Color
import Value exposing (Value)


sourceText : Cell -> List String
sourceText cell =
    cell.text
        |> List.filter (\s -> String.left 1 s /= "#")


{-|

    TODO: Dummy implementation of evaluate : Cell -> Cell

-}
evaluate : String -> Cell -> Cell
evaluate str cell =
    { cell | text = String.lines str, value = Nothing, cellState = CSView }


view : Int -> String -> Cell -> Element FrontendMsg
view width cellContents cell =
    E.column
        [ E.paddingEach { top = 0, right = 0, bottom = 0, left = 0 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.1 0.1 0.1)
        , E.inFront
            (E.row [ E.spacing 12, E.width (E.px width) ]
                [ E.row [ E.alignRight, E.spacing 12 ]
                    [ newCellAt cell.cellState cell.index
                    , editCellAt cell.cellState cell.index
                    , clearCellAt cell.cellState cell.index
                    , evalCellAt cell.cellState cell.index
                    , viewIndex cell
                    ]
                ]
            )
        ]
        [ viewSource width cell cellContents
        , viewValue width cell
        ]


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
        , Element.Font.color (E.rgb 0.1 0.1 0.1)
        , E.paddingEach { top = 8, right = 8, bottom = 12, left = 8 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.8 0.8 0.9)
        ]
        [ E.text (cell.value |> Maybe.withDefault "-- unevaluated --")
        ]


viewIndex : Cell -> Element msg
viewIndex cell =
    E.el [ E.paddingXY 8 8, E.alignRight ] (E.text <| String.fromInt (cell.index + 1))


viewSource_ : Int -> Cell -> Element msg
viewSource_ width cell =
    E.column
        [ E.spacing 8
        , E.paddingEach { top = 8, right = 8, bottom = 8, left = 8 }
        , E.height (E.px 80)
        , E.width (E.px width)
        , Background.color (E.rgb 0.1 0.1 0.1)
        ]
        (cell.text |> List.map E.text)


editCell : Int -> Cell -> String -> Element FrontendMsg
editCell width cell cellContent =
    E.column
        [ E.spacing 8
        , E.paddingEach { top = 1, right = 1, bottom = 1, left = 1 }
        , E.width (E.px width)

        -- , E.height E.fill
        , Background.color (E.rgb 0.1 0.1 0.8)
        ]
        [ Element.Input.multiline
            [ Background.color (E.rgb 0.8 0.8 1.0)
            , Element.Font.color Color.black
            , E.height (E.px 80)
            ]
            { onChange = InputElmCode
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
