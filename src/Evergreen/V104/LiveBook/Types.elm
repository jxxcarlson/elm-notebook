module Evergreen.V104.LiveBook.Types exposing (..)

import Time


type VisualType
    = VTChart
    | VTSvg
    | VTImage


type CellValue
    = CVNone
    | CVString String
    | CVVisual VisualType (List String)
    | CVPlot2D (List String) (List ( Float, Float ))


type CellState
    = CSEdit
    | CSView


type alias Cell =
    { index : Int
    , text : List String
    , bindings : List String
    , expression : String
    , value : CellValue
    , cellState : CellState
    , locked : Bool
    }


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
    , initialStateString : String
    , stateExpression : String
    , stateBindings : List String
    , fastTickInterval : Float
    , stopExpressionString : String
    }
