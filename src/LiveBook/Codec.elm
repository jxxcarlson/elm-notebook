module LiveBook.Codec exposing (..)

import Codec exposing (Codec, Value)
import Time
import Types exposing (CellValue(..), VisualType(..))


type alias Book =
    { id : String
    , dirty : Bool
    , slug : String
    , origin : Maybe String
    , author : String
    , createdAt : Time.Posix
    , updatedAt : Time.Posix
    , public : Bool
    , title : String
    , cells : List Cell
    , currentIndex : Int
    }


type alias Cell =
    { index : Int, text : List String, value : CellValue, cellState : CellState }


cellCodec : Codec Cell
cellCodec =
    Codec.object Cell
        |> Codec.field "index" .index Codec.int
        |> Codec.field "text" .text (Codec.list Codec.string)
        |> Codec.field "value" .value cellValueCodec
        |> Codec.field "cellState" .cellState cellStateCodec
        |> Codec.buildObject



--,  cellState : CellState } value : CellValue


cellValueCodec : Codec CellValue
cellValueCodec =
    Codec.custom
        (\fcvnone cvstring cvvisual value ->
            case value of
                CVNone ->
                    fcvnone

                CVString s ->
                    cvstring s

                CVVisual s ls ->
                    cvvisual s ls
        )
        |> Codec.variant0 "CVNone" CVNone
        |> Codec.variant1 "CVString" CVString Codec.string
        |> Codec.variant2 "CVVisual" CVVisual visualTypeCodec (Codec.list Codec.string)
        |> Codec.buildCustom


visualTypeCodec : Codec VisualType
visualTypeCodec =
    Codec.custom
        (\fvtchart fvtimage value ->
            case value of
                VTChart ->
                    fvtchart

                VTImage ->
                    fvtimage
        )
        |> Codec.variant0 "VTChart" VTChart
        |> Codec.variant0 "VTImage" VTImage
        |> Codec.buildCustom


type CellState
    = CSEdit
    | CSView


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



--|> Codec.field "value" .value cellValueCodec
--|> Codec.field "cellState" .cellState cellStateCodec


type alias Point =
    { x : Float
    , y : Float
    }


pointCodec : Codec Point
pointCodec =
    Codec.object Point
        |> Codec.field "x" .x Codec.float
        |> Codec.field "y" .y Codec.float
        |> Codec.buildObject
