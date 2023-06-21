module LiveBook.Book exposing (scratchPad, new)

import Types exposing (Book, Cell, CellState(..))
import Time



scratchPad : Book
scratchPad =
    { id = "_scratchpad_"
    , slug = "_scratchpad_"
    , author = "anonymous"
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
    , createdAt = Time.millisToPosix 0
    , updatedAt = Time.millisToPosix 0
    , public = False
    , title = title
    , cells = [ ]
    , currentIndex = 0
    }


newBook : String -> String -> Book
newBook author title ={
   id = ""
  , slug = ""
  , author = author
  , createdAt = Time.millisToPosix 0
  , updatedAt = Time.millisToPosix 0
  , public = False
  , title = title
  , cells = []
  , currentIndex = 0 }
