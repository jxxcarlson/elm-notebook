module LiveBook.Cell exposing (view)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Font
import Types exposing (Cell, FrontendMsg(..))
import UILibrary.Button as Button
import UILibrary.Color as Color
import Value exposing (Value)


sourceText : Cell -> List String
sourceText cell =
    cell.text
        |> List.filter (\s -> String.left 1 s /= "#")


evaluate : Cell -> String
evaluate cell =
    --case sourceText cell |> String.join "\n" |> Eval.eval of
    --    Ok value ->
    --        Value.toString value
    --
    --    Err error ->
    --        "Oops: errror"
    "Eval: " :: sourceText cell |> String.join " "


view : Int -> Cell -> Element FrontendMsg
view width cell =
    E.column
        [ E.paddingEach { top = 8, right = 0, bottom = 0, left = 0 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.1 0.1 0.1)
        , E.inFront
            (E.row [ E.spacing 12, E.width (E.px width) ]
                [ E.row [ E.alignRight, E.spacing 12 ]
                    [ newCellAt cell.index
                    , editCellAt cell.index
                    , evalCellAt cell.index
                    , viewIndex cell
                    ]
                ]
            )
        ]
        [ viewSource width cell
        , viewValue width cell
        ]


viewIndex : Cell -> Element msg
viewIndex cell =
    E.el [ E.paddingXY 8 8, E.alignRight ] (E.text <| String.fromInt (cell.index + 1))


viewValue width cell =
    E.paragraph
        [ E.spacing 8
        , Element.Font.color (E.rgb 0.1 0.1 0.1)
        , E.paddingEach { top = 8, right = 8, bottom = 12, left = 8 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.8 0.8 0.8)
        ]
        [ E.text
            (evaluate cell)
        ]


viewSource : Int -> Cell -> Element msg
viewSource width cell =
    case cell.cellState of
        Types.CSView ->
            viewSource_ width cell

        Types.CSEdit ->
            editCell width cell


editCell : Int -> Cell -> Element msg
editCell width cell =
    E.column
        [ E.spacing 8
        , E.paddingEach { top = 0, right = 8, bottom = 8, left = 8 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.1 0.1 0.8)
        ]
        (cell.text |> List.map E.text)


viewSource_ : Int -> Cell -> Element msg
viewSource_ width cell =
    E.column
        [ E.spacing 8
        , E.paddingEach { top = 0, right = 8, bottom = 8, left = 8 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.1 0.1 0.1)
        ]
        (cell.text |> List.map E.text)


newCellAt : Int -> Element FrontendMsg
newCellAt index =
    Button.smallPrimary { msg = NewCell index, status = Button.ActiveTransparent, label = Button.Text "New", tooltipText = Just "Insert  new cell" }


editCellAt : Int -> Element FrontendMsg
editCellAt index =
    Button.smallPrimary { msg = EditCell index, status = Button.ActiveTransparent, label = Button.Text "Edit", tooltipText = Just "Edit cell" }


evalCellAt : Int -> Element FrontendMsg
evalCellAt index =
    Button.smallPrimary { msg = EvalCell index, status = Button.ActiveTransparent, label = Button.Text "Eval", tooltipText = Just "Evaluate cell" }
