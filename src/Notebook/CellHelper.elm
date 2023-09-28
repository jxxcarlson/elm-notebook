module Notebook.CellHelper exposing (addCellToBook, updateBookWithCell, updateBookWithCellIndexAndReplData)

import List.Extra
import Notebook.Book exposing (Book)
import Notebook.Cell exposing (Cell, CellState(..), CellValue(..))
import Notebook.Types



-- HELPERS


updateBookWithCellIndexAndReplData : Int -> Notebook.Types.ReplData -> Book -> Book
updateBookWithCellIndexAndReplData cellIndex replData book =
    case List.Extra.getAt cellIndex book.cells of
        Nothing ->
            book

        Just targetCell ->
            updateBookWithCell { targetCell | value = CVString replData.value } book


updateBookWithCell : Cell -> Book -> Book
updateBookWithCell cell book =
    if cell.index < 0 || cell.index >= List.length book.cells then
        -- cell is out of bounds, do not update
        book

    else
        let
            prefix =
                List.filter (\currentCell -> currentCell.index < cell.index) book.cells
                    |> List.map (\c -> { c | cellState = CSView })

            suffix =
                List.filter (\currentCell -> currentCell.index > cell.index) book.cells
                    |> List.map (\c -> { c | cellState = CSView })
        in
        { book | cells = prefix ++ (cell :: suffix), dirty = True }


addCellToBook : Cell -> Book -> Book
addCellToBook cell book =
    if cell.index < 0 || cell.index >= List.length book.cells + 1 then
        -- cell is out of bounds, do not update
        book

    else
        let
            prefix =
                List.filter (\currentCell -> currentCell.index < cell.index) book.cells

            _ =
                cell

            suffix =
                List.filter (\currentCell -> currentCell.index >= cell.index) book.cells
                    |> List.map (\c -> { c | index = c.index + 1 })
        in
        { book | cells = prefix ++ (cell :: suffix), dirty = True }
