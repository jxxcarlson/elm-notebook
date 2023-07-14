module LiveBook.Book exposing (initializeCellState, new, scratchPad)

import LiveBook.Config
import LiveBook.Types exposing (Book, Cell, CellState(..), CellValue(..))
import Time


scratchPad : String -> Book
scratchPad username =
    { id = "_scratchpad_"
    , slug = username ++ ".scratchpad"
    , origin = Nothing
    , author = username
    , dirty = False
    , createdAt = Time.millisToPosix 0
    , updatedAt = Time.millisToPosix 0
    , public = False
    , title = "Scatchpad"
    , cells =
        [ { index = 0
          , text = [ "# EvalTest: ", "> 1 + 1 == 2" ]
          , bindings = []
          , expression = ""
          , value = CVNone
          , cellState = CSView
          , locked = False
          }
        ]
    , currentIndex = 0
    , initialStateString = initialStateString
    , stateExpression = initialStateExpression
    , stateBindings = initialStateBindings
    , fastTickInterval = LiveBook.Config.fastTickInterval
    }


new : String -> String -> Book
new author title =
    { id = "??"
    , slug = "??"
    , author = author
    , origin = Nothing
    , dirty = False
    , createdAt = Time.millisToPosix 0
    , updatedAt = Time.millisToPosix 0
    , public = False
    , title = title
    , cells =
        [ { index = 0
          , text = [ "# EvalTest: ", "> 1 + 1 == 42" ]
          , bindings = []
          , expression = ""
          , value = CVString "True"
          , cellState = CSView
          , locked = False
          }
        ]
    , currentIndex = 0
    , initialStateString = initialStateString
    , stateExpression = initialStateExpression
    , stateBindings = initialStateBindings
    , fastTickInterval = LiveBook.Config.fastTickInterval
    }


newBook : String -> String -> Book
newBook author title =
    { id = ""
    , slug = ""
    , origin = Nothing
    , author = author
    , dirty = False
    , createdAt = Time.millisToPosix 0
    , updatedAt = Time.millisToPosix 0
    , public = False
    , title = title
    , cells = []
    , currentIndex = 0
    , initialStateString = initialStateString
    , stateExpression = initialStateExpression
    , stateBindings = initialStateBindings
    , fastTickInterval = LiveBook.Config.fastTickInterval
    }


initialStateString =
    "10"


initialStateExpression =
    "if state <= 0 then 0 else state + ds p0"


initialStateBindings =
    [ "ds p = if p < 0.5 then -1 else 1" ]


initializeCellState : Book -> Book
initializeCellState book =
    { book | cells = List.map (\cell -> { cell | cellState = CSView }) book.cells }
