module Notebook.ViewCell exposing (view)

import Dict exposing (Dict)
import Element as E exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Events
import Element.Font as Font
import Element.Input
import Element.Lazy
import List.Extra
import Types exposing (FrontendModel, FrontendMsg(..))
import UILibrary.Button as Button
import UILibrary.Color as Color
import View.Button exposing (runCell)
import View.CellThemed


view : ViewData -> String -> Cell -> Element FrontendMsg
view viewData cellContents cell =
    E.column
        [ E.paddingEach { top = 0, right = 0, bottom = 0, left = 0 }
        , E.width (E.px viewData.width)
        , Background.color (E.rgb 0.1 0.1 0.1)
        ]
        [ E.row
            [ E.width (E.px viewData.width) ]
            [ viewSourceAndValue viewData cellContents cell
            ]
        ]


viewSourceAndValue : ViewData -> String -> Cell -> Element FrontendMsg
viewSourceAndValue viewData cellContents cell =
    E.column []
        [ E.el [ E.alignRight ] (controls viewData.width cell)
        , viewSource (viewData.width - controlWidth) cell cellContents
        , viewValue viewData cell
        ]


viewSourceAndValue1 : ViewData -> String -> Cell -> Element FrontendMsg
viewSourceAndValue1 viewData cellContents cell =
    E.column [ E.inFront (E.el [ E.alignRight ] (controls viewData.width cell)) ]
        [ viewSource (viewData.width - controlWidth) cell cellContents
        , viewValue viewData cell
        ]


controlBGView =
    Background.color (E.rgb255 220 220 255)


controlBGEdit =
    Background.color (E.rgb 0.8 0.8 1.0)


controls width_ cell =
    case cell.cellState of
        CSView ->
            --E.el [ E.moveDown 24] (viewIndex cell)
            E.el [ controlBGView, E.width (E.px width_), E.height (E.px 32) ]
                (E.el [ E.alignRight ] (viewIndex cell))

        CSEdit ->
            E.el [ controlBGEdit, E.width (E.px width_), E.paddingEach { left = 0, right = 12, bottom = 0, top = 0 } ]
                (E.row
                    [ E.spacing 2
                    , E.alignRight
                    , E.height (E.px 32)
                    , E.spacing 4
                    , E.paddingEach { top = 2, bottom = 2, left = 8, right = 4 }
                    ]
                    [ runCell cell.index
                    , newCellAt cell.cellState cell.index
                    , deleteCellAt cell.cellState cell.index
                    , clearCellAt cell.cellState cell.index
                    , View.Button.lockCell cell
                    , viewIndex cell
                    ]
                )


controlWidth =
    0


isSimulation cell =
    let
        source =
            cell.text |> String.join "\n"
    in
    String.contains "timeSeries" source || String.contains "evalSvg" source


viewSource : Int -> Cell -> String -> Element FrontendMsg
viewSource width cell cellContent =
    case cell.cellState of
        CSView ->
            viewSource_ width cell

        CSEdit ->
            editCell width cell cellContent


viewValue : ViewData -> Cell -> Element FrontendMsg
viewValue viewData cell =
    let
        realWidth =
            viewData.width - controlWidth
    in
    case cell.value of
        CVNone ->
            E.none

        CVString str ->
            let
                cellHeight_ =
                    List.length (String.lines str) |> (\x -> scale 14.5 x + 35)
            in
            par realWidth
                [ View.CellThemed.renderFull (scale 1.0 realWidth) cellHeight_ str ]

        CVPlot2D args data ->
            case List.Extra.unconsLast args of
                Nothing ->
                    E.image
                        [ E.width (E.px realWidth) ]
                        { src = getArg 0 args, description = "image" }

                Just ( dataVariable, args_ ) ->
                    let
                        options =
                            LiveBook.Utility.keyValueDict (("width:" ++ String.fromInt realWidth) :: args_)

                        innerArgs =
                            List.filter (\s -> not (String.contains s ":")) args_

                        kind =
                            List.head innerArgs |> Maybe.withDefault "line"
                    in
                    --case LiveBook.Eval.evaluateWithCumulativeBindingsToResult Dict.empty viewData.book.cells dataVariable of
                    --    Err _ ->
                    --        E.text "Error (22)"
                    --
                    --    Ok listPairs ->
                    --@@dataVariable: "data"
                    --(index):260 @@args_: ["plot2D","line"]
                    LiveBook.Chart.plot2D "line" options data

        CVVisual vt args ->
            Element.Lazy.lazy3 renderVT viewData vt args


par width =
    E.paragraph
        [ E.spacing 8
        , Font.color Color.black

        --, E.paddingEach { top = 8, right = 0, bottom = 12, left = 8 }
        , E.width (E.px width)
        , Background.color (E.rgb 0.85 0.85 0.95)
        ]


renderVT : ViewData -> VisualType -> List String -> Element FrontendMsg
renderVT viewData vt args =
    let
        realWidth =
            viewData.width - controlWidth
    in
    case vt of
        VTImage ->
            case List.Extra.unconsLast args of
                Nothing ->
                    E.image
                        [ E.width (E.px realWidth) ]
                        { src = getArg 0 args, description = "image" }

                Just ( url, args_ ) ->
                    let
                        options =
                            LiveBook.Utility.keyValueDict args_

                        width_ =
                            case Dict.get "width" options of
                                Just w ->
                                    w |> String.toInt |> Maybe.withDefault realWidth

                                Nothing ->
                                    realWidth
                    in
                    E.image
                        [ E.width (E.px width_) ]
                        { src = url, description = "image" }

        VTSvg ->
            let
                cleanArgs =
                    args
                        |> List.filter (\s -> not (String.contains s "#"))
                        |> List.map (String.replace "> svg " "")
            in
            Element.Lazy.lazy LiveBook.SVG.render cleanArgs

        VTChart ->
            case List.Extra.unconsLast args of
                Nothing ->
                    E.image
                        [ E.width (E.px realWidth) ]
                        { src = getArg 0 args, description = "image" }

                Just ( dataVariable, args_ ) ->
                    let
                        options =
                            LiveBook.Utility.keyValueDict (("width:" ++ String.fromInt realWidth) :: args_)

                        innerArgs =
                            List.filter (\s -> not (String.contains s ":")) args_

                        kind =
                            List.head innerArgs |> Maybe.withDefault "line"
                    in
                    LiveBook.Chart.chart kind options (dataVariable |> LiveBook.Eval.transformWordsWithKVDict viewData.kvDict)


getArg : Int -> List String -> String
getArg k args =
    List.Extra.getAt k args |> Maybe.withDefault "--"


viewIndex : Cell -> Element FrontendMsg
viewIndex cell =
    let
        action =
            case cell.cellState of
                CSView ->
                    Element.Events.onMouseDown (EditCell cell)

                CSEdit ->
                    Element.Events.onMouseDown (EvalCell cell.index)

        padding =
            case cell.cellState of
                CSView ->
                    E.paddingEach { top = 9, bottom = 0, left = 0, right = 16 }

                CSEdit ->
                    E.paddingEach { top = 0, bottom = 0, left = 0, right = 0 }
    in
    E.el
        [ action
        , padding
        ]
        (E.text <| "Cell " ++ String.fromInt (cell.index + 1))


viewSource_ width cell =
    let
        processedLines : List String
        processedLines =
            LiveBook.PreProcess.cellContents cell

        delta nLines =
            -- TODO: Bad code!
            if nLines == 1 then
                30

            else if nLines < 3 then
                10

            else if nLines < 8 then
                20

            else if nLines < 11 then
                40

            else
                50

        cellHeight_ =
            List.length processedLines |> (\x -> scale 14.0 x + delta 0)

        source =
            processedLines |> String.join "\n"
    in
    E.column
        [ E.spacing 0
        , if not cell.locked then
            Element.Events.onMouseDown (EditCell cell)

          else
            Element.Events.onMouseDown NoOpFrontendMsg
        , E.width (E.px width)
        , Font.size 14
        ]
        [ View.CellThemed.renderFull (scale 1.0 width)
            cellHeight_
            source
        ]


stepFunction : List ( number, number ) -> number -> number
stepFunction steps x =
    List.Extra.find (\( a, b ) -> x <= a) steps |> Maybe.map Tuple.second |> Maybe.withDefault 0


scale : Float -> Int -> Int
scale factor x =
    round <| factor * toFloat x


editCell : Int -> Cell -> String -> Element FrontendMsg
editCell width cell cellContent =
    E.el [ E.paddingXY 8 4, Background.color (E.rgb 0.85 0.85 1.0) ]
        (E.column
            [ E.spacing 8
            , E.paddingEach { top = 1, right = 1, bottom = 1, left = 1 }
            , E.width (E.px <| width - 16)
            ]
            [ Element.Input.multiline
                [ Background.color (E.rgb 0.8 0.8 1.0)
                , Element.Border.width 2
                , Element.Border.color (E.rgb 0.6 0.6 1.0)
                , Font.color Color.black
                ]
                { onChange = InputElmCode cell.index
                , text = cellContent
                , placeholder = Nothing
                , label = Element.Input.labelHidden ""
                , spellcheck = False
                }
            ]
        )


newCellAt : CellState -> Int -> Element FrontendMsg
newCellAt cellState index =
    case cellState of
        CSView ->
            Button.smallPrimary { msg = NewCell index, status = Button.Active, label = Button.Text "New", tooltipText = Just "Insert  new cell" }

        CSEdit ->
            Button.smallPrimary { msg = NewCell index, status = Button.Active, label = Button.Text "New", tooltipText = Just "Insert  new cell" }


deleteCellAt : CellState -> Int -> Element FrontendMsg
deleteCellAt cellState index =
    --case cellState of
    --    CSView ->
    Button.smallPrimary { msg = DeleteCell index, status = Button.Active, label = Button.Text "Delete", tooltipText = Just "Delete cell" }



--CSEdit ->
--    E.none


clearCellAt : CellState -> Int -> Element FrontendMsg
clearCellAt cellState index =
    Button.smallPrimary { msg = ClearCell index, status = Button.Active, label = Button.Text "Clear", tooltipText = Just "Edit cell" }
