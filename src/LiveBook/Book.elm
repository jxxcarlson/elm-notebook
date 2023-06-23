module LiveBook.Book exposing (initializeCellState, new, scratchPad)

import Time
import Types exposing (Book, Cell, CellState(..))


scratchPad : String -> Book
scratchPad username =
    { id = "_scratchpad_"
    , slug = username ++ ".scratchpad"
    , author = username
    , dirty = False
    , createdAt = Time.millisToPosix 0
    , updatedAt = Time.millisToPosix 0
    , public = False
    , title = "Scatchpad"
    , cells = [ { index = 0, text = [ "# Example: ", "1 + 1 == 2" ], value = Just "True", cellState = CSView } ]
    , currentIndex = 0
    }


new author title =
    { id = "??"
    , slug = "??"
    , author = author
    , dirty = False
    , createdAt = Time.millisToPosix 0
    , updatedAt = Time.millisToPosix 0
    , public = False
    , title = title
    , cells = [ { index = 0, text = [ "# Example: ", "1 + 1 == 2" ], value = Just "True", cellState = CSView } ]
    , currentIndex = 0
    }


newBook : String -> String -> Book
newBook author title =
    { id = ""
    , slug = ""
    , author = author
    , dirty = False
    , createdAt = Time.millisToPosix 0
    , updatedAt = Time.millisToPosix 0
    , public = False
    , title = title
    , cells = []
    , currentIndex = 0
    }


initializeCellState : Book -> Book
initializeCellState book =
    { book | cells = List.map (\cell -> { cell | cellState = CSView }) book.cells }
