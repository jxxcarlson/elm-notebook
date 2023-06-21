module LiveBook.Types exposing (Book, Cell, CellState(..))


type alias Cell =
    { index : Int, text : List String, value : Maybe String, cellState : CellState }


type CellState
    = CSEdit
    | CSView


type alias Book =
    { id : String
    , slug : String
    , author : String
    , title : String
    , cells : List Cell
    , selectedCell : Maybe Int
    , selectedCellState : Maybe CellState
    }
