module Notebook.View exposing (view)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Events
import Element.Font as Font
import Element.Input
import List.Extra
import Notebook.Book exposing (ViewData)
import Notebook.Cell exposing (Cell, CellState(..), CellType(..), CellValue(..))
import Notebook.Utility as Utility
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
        , Background.color (E.rgb255 99 106 122)
        ]
        [ E.row
            [ E.width (E.px viewData.width) ]
            [ viewSourceAndValue viewData cellContents cell
            ]
        ]


viewSourceAndValue : ViewData -> String -> Cell -> Element FrontendMsg
viewSourceAndValue orignalviewData cellContents cell =
    let
        style =
            case ( cell.cellState, cell.tipe ) of
                ( CSEdit, _ ) ->
                    [ Element.Border.color (E.rgb 0.75 0.75 0.75)
                    , editBGColor
                    , Element.Border.widthEach
                        { bottom = 1
                        , left = 0
                        , right = 0
                        , top = 1
                        }
                    ]

                ( CSView, CTCode ) ->
                    [ Element.Border.color (E.rgb 0.75 0.75 0.75)
                    , Element.Border.widthEach
                        { bottom = 0
                        , left = 0
                        , right = 0
                        , top = 1
                        }
                    ]

                ( CSView, CTMarkdown ) ->
                    [ Element.Border.color (E.rgb 0.75 0.75 0.75)
                    , Element.Border.widthEach
                        { bottom = 0
                        , left = 0
                        , right = 0
                        , top = 1
                        }
                    ]

        viewData =
            { orignalviewData | width = orignalviewData.width - 24 }
    in
    E.column ([ Background.color (Utility.cellColor cell.tipe), E.paddingXY 6 12, E.spacing 4 ] ++ style)
        [ E.el [ E.alignRight, Background.color (Utility.cellColor cell.tipe) ] (controls viewData.width cell)
        , viewSource (viewData.width - controlWidth) cell cellContents
        , viewValue viewData cell
        ]


controlBGView =
    Background.color (E.rgb255 220 220 255)


controlBGEdit =
    Background.color (E.rgb 0.8 0.8 1.0)


bgColor cell =
    Background.color (Utility.cellColor cell.tipe)


controls width_ cell =
    case cell.cellState of
        CSView ->
            E.none

        CSEdit ->
            E.row
                [ controlBGEdit
                , E.width (E.px (width_ - 3))
                , E.centerX
                , E.paddingEach { left = 0, right = 12, bottom = 0, top = 0 }
                , bgColor cell
                ]
                [ E.row
                    [ E.spacing 2
                    , E.alignLeft
                    , E.height (E.px 32)
                    , E.spacing 4
                    , E.paddingEach { top = 2, bottom = 2, left = 8, right = 4 }
                    ]
                    [ newCodeCellAt cell.cellState cell.index
                    , newMarkdownCellAt cell.cellState cell.index
                    , runCell cell.tipe cell.index
                    ]
                , E.row
                    [ E.spacing 2
                    , E.alignRight
                    , E.height (E.px 32)
                    , E.spacing 4
                    , E.paddingEach { top = 2, bottom = 2, left = 8, right = 4 }
                    ]
                    [ deleteCellAt cell.cellState cell.index
                    , clearCellAt cell.cellState cell.index
                    , View.Button.lockCell cell
                    , viewIndex cell
                    ]
                ]


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
    case cell.tipe of
        CTCode ->
            case cell.cellState of
                CSView ->
                    viewSource_ "" width cell

                CSEdit ->
                    editCell width cell cellContent

        CTMarkdown ->
            case cell.cellState of
                CSView ->
                    viewSource_ "" width cell

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
            par realWidth
                [ View.CellThemed.renderFull cell.tipe (scale 1.0 realWidth) str ]

        CVMarkdown str ->
            par realWidth
                -- TODO: fix this outrageous hack
                [ E.none ]



--CVPlot2D args data ->
--    case List.Extra.unconsLast args of
--        Nothing ->
--            E.image
--                [ E.width (E.px realWidth) ]
--                { src = getArg 0 args, description = "image" }
--
--        Just ( dataVariable, args_ ) ->
--            let
--                options =
--                    Notebook.Utility.keyValueDict (("width:" ++ String.fromInt realWidth) :: args_)
--
--                innerArgs =
--                    List.filter (\s -> not (String.contains s ":")) args_
--
--                kind =
--                    List.head innerArgs |> Maybe.withDefault "line"
--            in
--            --case Notebook.Eval.evaluateWithCumulativeBindingsToResult Dict.empty viewData.book.cells dataVariable of
--            --    Err _ ->
--            --        E.text "Error (22)"
--            --
--            --    Ok listPairs ->
--            --@@dataVariable: "data"
--            --(index):260 @@args_: ["plot2D","line"]
--            Notebook.Chart.plot2D "line" options data
--
--CVVisual vt args ->
--    Element.Lazy.lazy3 renderVT viewData vt args


par width =
    E.paragraph
        [ E.spacing 8
        , Font.color Color.black
        , E.width (E.px width)
        , Background.color (E.rgb 0.85 0.85 0.95)
        ]



--
--renderVT : ViewData -> VisualType -> List String -> Element FrontendMsg
--renderVT viewData vt args =
--    let
--        realWidth =
--            viewData.width - controlWidth
--    in
--    case vt of
--        VTImage ->
--            case List.Extra.unconsLast args of
--                Nothing ->
--                    E.image
--                        [ E.width (E.px realWidth) ]
--                        { src = getArg 0 args, description = "image" }
--
--                Just ( url, args_ ) ->
--                    let
--                        options =
--                            Notebook.Utility.keyValueDict args_
--
--                        width_ =
--                            case Dict.get "width" options of
--                                Just w ->
--                                    w |> String.toInt |> Maybe.withDefault realWidth
--
--                                Nothing ->
--                                    realWidth
--                    in
--                    E.image
--                        [ E.width (E.px width_) ]
--                        { src = url, description = "image" }
--
--        VTSvg ->
--            let
--                cleanArgs =
--                    args
--                        |> List.filter (\s -> not (String.contains s "#"))
--                        |> List.map (String.replace "> svg " "")
--            in
--            Element.Lazy.lazy Notebook.SVG.render cleanArgs
--
--        VTChart ->
--            case List.Extra.unconsLast args of
--                Nothing ->
--                    E.image
--                        [ E.width (E.px realWidth) ]
--                        { src = getArg 0 args, description = "image" }
--
--                Just ( dataVariable, args_ ) ->
--                    let
--                        options =
--                            Notebook.Utility.keyValueDict (("width:" ++ String.fromInt realWidth) :: args_)
--
--                        innerArgs =
--                            List.filter (\s -> not (String.contains s ":")) args_
--
--                        kind =
--                            List.head innerArgs |> Maybe.withDefault "line"
--                    in
--                    Notebook.Chart.chart kind options (dataVariable |> Notebook.Eval.transformWordsWithKVDict viewData.kvDict)


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


viewSource_ prefix width cell =
    let
        cellHeight_ =
            40

        source =
            cell.text
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
        [ View.CellThemed.renderFull cell.tipe (scale 1.0 width) (prefix ++ source)
        ]


stepFunction : List ( number, number ) -> number -> number
stepFunction steps x =
    List.Extra.find (\( a, b ) -> x <= a) steps |> Maybe.map Tuple.second |> Maybe.withDefault 0


scale : Float -> Int -> Int
scale factor x =
    round <| factor * toFloat x


editBGColor =
    Background.color (E.rgb 0.4 0.4 0.5)


editCell : Int -> Cell -> String -> Element FrontendMsg
editCell width cell cellContent =
    E.el
        [ E.paddingXY 8 4
        , bgColor cell
        , Element.Border.color (E.rgb 1.0 0.6 0.6)
        , editBGColor
        ]
        (E.column
            [ E.spacing 8
            , E.paddingEach { top = 1, right = 1, bottom = 1, left = 1 }
            , E.width (E.px <| width - 16)
            ]
            [ Element.Input.multiline
                [ bgColor cell
                , Font.color Color.black
                , E.centerX
                , E.width (E.px <| width)
                ]
                { onChange = InputElmCode cell.index
                , text = cellContent
                , placeholder = Nothing
                , label = Element.Input.labelHidden ""
                , spellcheck = False
                }
            ]
        )


newCodeCellAt : CellState -> Int -> Element FrontendMsg
newCodeCellAt cellState index =
    case cellState of
        CSView ->
            Button.smallPrimary { msg = NewCodeCell index, status = Button.Active, label = Button.Text "New Code", tooltipText = Just "Insert  new cell" }

        CSEdit ->
            Button.smallPrimary { msg = NewCodeCell index, status = Button.Active, label = Button.Text "New Code", tooltipText = Just "Insert  new cell" }


newMarkdownCellAt : CellState -> Int -> Element FrontendMsg
newMarkdownCellAt cellState index =
    case cellState of
        CSView ->
            Button.smallPrimary { msg = NewMarkdownCell index, status = Button.Active, label = Button.Text "New Text", tooltipText = Just "Insert  new cell" }

        CSEdit ->
            Button.smallPrimary { msg = NewMarkdownCell index, status = Button.Active, label = Button.Text "New Text", tooltipText = Just "Insert  new cell" }


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
