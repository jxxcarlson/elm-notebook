module LiveBook.Book exposing (new, scratchPad)

import Time
import Types exposing (Book, Cell, CellState(..))


scratchPad : Book
scratchPad =
    { id = "_scratchpad_"
    , slug = "_scratchpad_"
    , author = "anonymous"
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
    , cells = []
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
