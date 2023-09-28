module Notebook.Cell exposing (..)


type alias Cell =
    { index : Int
    , text : String
    , tipe : CellType
    , value : CellValue
    , cellState : CellState
    , locked : Bool
    }


type CellType
    = CTCode
    | CTMarkdown


type CellValue
    = CV String
    | CVMarkdown
    | CVNone


type CellState
    = CSEdit
    | CSView
