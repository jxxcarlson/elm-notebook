module LiveBook.Types exposing (Book, Cell, CellState(..), CellValue(..), ViewData, VisualType(..))

import Dict exposing (Dict)
import Time


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
    { index : Int
    , text : List String
    , bindings : List String
    , expression : String
    , value : CellValue
    , cellState : CellState
    , locked : Bool
    }


type CellValue
    = CVNone
    | CVString String
    | CVVisual VisualType (List String)


type VisualType
    = VTChart
    | VTPlot2D
    | VTSvg
    | VTImage


type CellState
    = CSEdit
    | CSView


type alias ViewData =
    { book : Book
    , kvDict : Dict String String
    , width : Int
    }
