module LiveBook.Update exposing
    ( clearCell
    , deleteCell_
    , editCell
    , evalCell
    , evalCell_
    , makeNewCell
    , updateCellText
    )

import List.Extra
import Livebook.Eval
import Types exposing (Cell, CellState(..), FrontendModel, FrontendMsg(..))


makeNewCell : FrontendModel -> Int -> ( FrontendModel, Cmd FrontendMsg )
makeNewCell model index =
    let
        newCell =
            { index = index + 1
            , text = [ "# New cell (" ++ String.fromInt (index + 2) ++ ") ", "-- code --" ]
            , value = Nothing
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


updateCellText : FrontendModel -> Int -> String -> FrontendModel
updateCellText model index str =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            model

        Just cell_ ->
            let
                updatedCell =
                    { cell_ | text = str |> String.split "\n" }

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
            { model | cellContent = str, currentBook = newBook }


deleteCell_ : Int -> FrontendModel -> FrontendModel
deleteCell_ index model =
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
            { model | currentCellIndex = cell_.index, cellContent = cell_.text |> String.join "\n", currentBook = newBook }


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
                    { cell_ | text = [ "" ] }

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


evalCell_ : Int -> FrontendModel -> FrontendModel
evalCell_ index model =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            model

        Just cell_ ->
            let
                updatedCell =
                    Livebook.Eval.evaluateWithCumulativeBindings model.currentBook.cells cell_

                prefix =
                    List.filter (\cell -> cell.index < index) model.currentBook.cells
                        |> List.map (\cell -> { cell | cellState = CSView })

                suffix =
                    List.filter (\cell -> cell.index > index) model.currentBook.cells

                oldBook =
                    model.currentBook

                newBook =
                    { oldBook | cells = prefix ++ (updatedCell :: suffix), dirty = True }

                --|> List.map LiveBook.Cell.evaluate
            in
            { model | currentBook = newBook }


evalCell : FrontendModel -> Int -> ( FrontendModel, Cmd FrontendMsg )
evalCell model index =
    ( evalCell_ index model, Cmd.none )
