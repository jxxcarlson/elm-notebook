module Evergreen.V1.LiveBook.Types exposing (..)


type CellState
    = CSEdit
    | CSView


type alias Cell =
    { index : Int
    , text : List String
    , value : Maybe String
    , cellState : CellState
    }


type alias Book =
    { id : String
    , slug : String
    , author : String
    , title : String
    , cells : List Cell
    , selectedCell : Maybe Int
    , selectedCellState : Maybe CellState
    }
