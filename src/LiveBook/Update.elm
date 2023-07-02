module LiveBook.Update exposing
    ( clearCell
    , clearNotebookValues
    , deleteCell
    , editCell
    , evalCell
    , executeCell_
    , makeNewCell
    , setCellValue
    , updateCellText
    )

import File.Select
import Lamdera
import List.Extra
import LiveBook.Eval
import LiveBook.Types
    exposing
        ( Book
        , Cell
        , CellState(..)
        , CellValue(..)
        , VisualType(..)
        )
import Types exposing (FrontendModel, FrontendMsg(..))


commands =
    [ "chart", "readinto", "image", "import" ]


clearNotebookValues : Book -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
clearNotebookValues book model =
    let
        newBook =
            { book | cells = List.map (\cell -> { cell | value = CVNone }) book.cells }
    in
    ( { model | currentBook = newBook }, Lamdera.sendToBackend (Types.SaveNotebook newBook) )


executeCell_ : Int -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
executeCell_ index model =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            ( model, Cmd.none )

        Just cell_ ->
            let
                commandWords =
                    cell_.text
                        |> List.filter (\line -> not <| String.startsWith "#" line)
                        |> String.join "\n"
                        |> String.replace ">" ""
                        |> String.trim
                        |> String.words

                updatedCell =
                    case List.head commandWords of
                        Nothing ->
                            { cell_ | cellState = CSView }

                        Just "image" ->
                            { cell_ | cellState = CSView, value = CVVisual VTImage (List.drop 1 commandWords) }

                        Just "chart" ->
                            { cell_ | cellState = CSView, value = CVVisual VTChart (List.drop 1 commandWords) }

                        Just "readinto" ->
                            { cell_ | cellState = CSView, value = CVString "*......*" }

                        Just "import" ->
                            { cell_ | cellState = CSView, value = CVString "*......*" }

                        _ ->
                            { cell_ | cellState = CSView }

                prefix =
                    List.filter (\cell -> cell.index < index) model.currentBook.cells
                        |> List.map (\cell -> { cell | cellState = CSView })

                suffix =
                    List.filter (\cell -> cell.index > index) model.currentBook.cells
                        |> List.map (\cell -> { cell | index = cell.index })
                        |> List.map (\cell -> { cell | cellState = CSView })

                oldBook =
                    model.currentBook

                newBook =
                    { oldBook | cells = prefix ++ (updatedCell :: suffix), dirty = True }

                cmd =
                    case List.head commandWords of
                        Nothing ->
                            Cmd.none

                        Just "readinto" ->
                            case List.Extra.getAt 1 commandWords of
                                Nothing ->
                                    Cmd.none

                                Just variable ->
                                    File.Select.file [ "text/csv" ] (StringDataSelected index variable)

                        Just "import" ->
                            case commandWords of
                                "import" :: identifier :: "as" :: variable :: _ ->
                                    Lamdera.sendToBackend (Types.GetData cell_.index identifier variable)

                                _ ->
                                    Cmd.none

                        _ ->
                            Cmd.none
            in
            ( { model | currentBook = newBook }, cmd )


makeNewCell : FrontendModel -> Int -> ( FrontendModel, Cmd FrontendMsg )
makeNewCell model index =
    let
        newCell =
            { index = index + 1
            , text = [ "# New cell (" ++ String.fromInt (index + 2) ++ ") ", "-- code --" ]
            , value = CVNone
            , cellState = CSEdit
            }

        prefix =
            List.filter (\cell -> cell.index <= index) model.currentBook.cells
                |> List.map (\cell -> { cell | cellState = CSView })

        suffix =
            List.filter (\cell -> cell.index > index) model.currentBook.cells
                |> List.map (\cell -> { cell | index = cell.index + 1 })
                |> List.map (\cell -> { cell | cellState = CSView })

        oldBook =
            model.currentBook

        newBook =
            { oldBook | cells = prefix ++ (newCell :: suffix), dirty = True }
    in
    ( { model
        | cellContent = ""
        , currentBook = newBook
        , currentCellIndex = index + 1
      }
    , Cmd.none
    )


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


setCellValue : FrontendModel -> Int -> CellValue -> FrontendModel
setCellValue model index cellValue =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            model

        Just cell_ ->
            { model | currentBook = updateBook { cell_ | value = cellValue } model.currentBook }


updateCellText : FrontendModel -> Int -> String -> FrontendModel
updateCellText model index str =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            model

        Just cell_ ->
            let
                updatedCell =
                    { cell_ | text = str |> String.split "\n" }
            in
            { model | cellContent = str, currentBook = updateBook updatedCell model.currentBook }


deleteCell : Int -> FrontendModel -> FrontendModel
deleteCell index model =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            model

        Just cell_ ->
            let
                prefix =
                    List.filter (\cell -> cell.index < index) model.currentBook.cells
                        |> List.map (\cell -> { cell | cellState = CSView })

                suffix =
                    List.filter (\cell -> cell.index > index) model.currentBook.cells
                        |> List.map (\cell -> { cell | cellState = CSView, index = cell.index - 1 })

                oldBook =
                    model.currentBook

                newBook =
                    { oldBook | cells = prefix ++ suffix, dirty = True }
            in
            { model | currentCellIndex = 0, currentBook = newBook }


editCell : FrontendModel -> Int -> ( FrontendModel, Cmd FrontendMsg )
editCell model index =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            ( model, Cmd.none )

        Just cell_ ->
            let
                updatedCell =
                    { cell_ | cellState = CSEdit }

                prefix =
                    List.filter (\cell -> cell.index < index) model.currentBook.cells
                        |> List.map (\cell -> { cell | cellState = CSView })

                suffix =
                    List.filter (\cell -> cell.index > index) model.currentBook.cells
                        |> List.map (\cell -> { cell | cellState = CSView })

                oldBook =
                    model.currentBook

                newBook =
                    { oldBook | cells = prefix ++ (updatedCell :: suffix), dirty = True }
            in
            ( { model | currentCellIndex = cell_.index, cellContent = cell_.text |> String.join "\n", currentBook = newBook }, Cmd.none )


clearCell : FrontendModel -> Int -> ( FrontendModel, Cmd FrontendMsg )
clearCell model index =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            ( model, Cmd.none )

        Just cell_ ->
            let
                updatedCell =
                    { cell_ | text = [ "" ], cellState = CSView }

                prefix =
                    List.filter (\cell -> cell.index < index) model.currentBook.cells
                        |> List.map (\cell -> { cell | cellState = CSView })

                suffix =
                    List.filter (\cell -> cell.index > index) model.currentBook.cells
                        |> List.map (\cell -> { cell | cellState = CSView })

                oldBook =
                    model.currentBook

                newBook =
                    { oldBook | cells = prefix ++ (updatedCell :: suffix), dirty = True }
            in
            ( { model | cellContent = "", currentBook = newBook }, Cmd.none )


evalCell : Int -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
evalCell index model =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            ( model, Cmd.none )

        Just cell_ ->
            let
                command =
                    cell_.text
                        |> List.head
                        |> Maybe.withDefault ""
                        |> String.replace ">" ""
                        |> String.words
                        |> List.map String.trim
                        |> List.head
            in
            if List.member command (List.map Just commands) then
                executeCell_ index model

            else
                ( evaluateWithCumulativeBindings model index cell_, Cmd.none )


evaluateWithCumulativeBindings model index cell_ =
    let
        updatedCell =
            LiveBook.Eval.evaluateWithCumulativeBindings model.kvDict model.currentBook.cells cell_

        prefix =
            List.filter (\cell -> cell.index < index) model.currentBook.cells
                |> List.map (\cell -> { cell | cellState = CSView })

        suffix =
            List.filter (\cell -> cell.index > index) model.currentBook.cells

        oldBook =
            model.currentBook

        newBook =
            { oldBook | cells = prefix ++ (updatedCell :: suffix), dirty = True }

        --|> List.map LiveBook.View.evaluate
    in
    { model | currentBook = updateBook updatedCell model.currentBook }



--evalCell : FrontendModel -> Int -> ( FrontendModel, Cmd FrontendMsg )
--evalCell model index =
--    evalCell_ index model
