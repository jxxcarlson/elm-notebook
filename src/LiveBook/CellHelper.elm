module LiveBook.CellHelper exposing (addCellToBook, updateBook)

import LiveBook.Types exposing (Book, Cell)



-- HELPERS


updateBook : Cell -> Book -> Book
updateBook cell book =
    if cell.index < 0 || cell.index >= List.length book.cells then
        -- cell is out of bounds, do not update
        book

    else
        let
            prefix =
                List.filter (\currentCell -> currentCell.index < cell.index) book.cells

            suffix =
                List.filter (\currentCell -> currentCell.index > cell.index) book.cells
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
