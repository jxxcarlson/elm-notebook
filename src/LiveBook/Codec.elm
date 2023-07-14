module LiveBook.Codec exposing (exportBook, importBook)

import Codec exposing (Codec, Error, Value)
import LiveBook.Types exposing (Book, Cell, CellState(..), CellValue(..), VisualType(..))
import Time


exportBook : Book -> String
exportBook book =
    Codec.encodeToString 4 bookCodec book


importBook : String -> Result Error Book
importBook str =
    Codec.decodeString bookCodec str


bookCodec : Codec Book
bookCodec =
    Codec.object Book
        |> Codec.field "id" .id Codec.string
        |> Codec.field "dirty" .dirty Codec.bool
        |> Codec.field "slug" .slug Codec.string
        |> Codec.field "origin" .origin (Codec.maybe Codec.string)
        |> Codec.field "author" .author Codec.string
        |> Codec.field "createdAt" .createdAt timeCodec
        |> Codec.field "updatedAt" .updatedAt timeCodec
        |> Codec.field "public" .public Codec.bool
        |> Codec.field "title" .title Codec.string
        |> Codec.field "cells" .cells (Codec.list cellCodec)
        |> Codec.field "currentIndex" .currentIndex Codec.int
        |> Codec.field "initialStateString" .initialStateString Codec.string
        |> Codec.field "stateExpression" .stateExpression Codec.string
        |> Codec.field "stateBindings" .stateBindings (Codec.list Codec.string)
        |> Codec.buildObject


timeCodec : Codec Time.Posix
timeCodec =
    Codec.map Time.millisToPosix Time.posixToMillis Codec.int


cellCodec : Codec Cell
cellCodec =
    Codec.object Cell
        |> Codec.field "index" .index Codec.int
        |> Codec.field "text" .text (Codec.list Codec.string)
        |> Codec.field "bindings" .bindings (Codec.list Codec.string)
        |> Codec.field "expression" .expression Codec.string
        |> Codec.field "value" .value cellValueCodec
        |> Codec.field "cellState" .cellState cellStateCodec
        |> Codec.field "locked" .locked Codec.bool
        |> Codec.buildObject



--,  cellState : CellState } value : CellValue


cellValueCodec : Codec CellValue
cellValueCodec =
    Codec.custom
        (\fcvnone cvstring cvvisual cvplot2d value ->
            case value of
                CVNone ->
                    fcvnone

                CVString s ->
                    cvstring s

                CVVisual s ls ->
                    cvvisual s ls

                CVPlot2D s lfp ->
                    cvplot2d s lfp
        )
        |> Codec.variant0 "CVNone" CVNone
        |> Codec.variant1 "CVString" CVString Codec.string
        |> Codec.variant2 "CVVisual" CVVisual visualTypeCodec (Codec.list Codec.string)
        |> Codec.variant2 "CVPlot2D" CVPlot2D (Codec.list Codec.string) (Codec.list (Codec.tuple Codec.float Codec.float))
        |> Codec.buildCustom



-- | CVPlot2D (List String) (List ( Float, Float ))


visualTypeCodec : Codec VisualType
visualTypeCodec =
    Codec.custom
        (\fvtchart fvtimage fvtsvg value ->
            case value of
                VTChart ->
                    fvtchart

                VTImage ->
                    fvtimage

                VTSvg ->
                    fvtsvg
        )
        |> Codec.variant0 "VTChart" VTChart
        |> Codec.variant0 "VTImage" VTImage
        |> Codec.variant0 "VTSvg" VTSvg
        |> Codec.buildCustom


cellStateCodec : Codec CellState
cellStateCodec =
    Codec.custom
        (\fcsedit fcsview value ->
            case value of
                CSEdit ->
                    fcsedit

                CSView ->
                    fcsview
        )
        |> Codec.variant0 "CSEdit" CSEdit
        |> Codec.variant0 "CSView" CSView
        |> Codec.buildCustom
