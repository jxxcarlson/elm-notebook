module LiveBook.Book exposing (scratchPad)

import LiveBook.Types exposing (Book, Cell, CellState(..))


scratchPad : String -> Book
scratchPad author =
    { id = "1234"
    , slug = "1234"
    , author = author
    , title = "Scatchpad"
    , cells = [ { index = 0, text = [ "# Example: ", "1 + 1 == 2" ], value = Just "True", cellState = LiveBook.Types.CSView } ]
    , selectedCell = Nothing
    , selectedCellState = Nothing
    }
