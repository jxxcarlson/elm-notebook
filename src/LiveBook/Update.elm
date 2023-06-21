module LiveBook.Update exposing
    ( clearCell
    , editCell
    , evalCell
    , makeNewCell
    )

import List.Extra
import LiveBook.Cell
import LiveBook.Types exposing (Cell, CellState(..))
import Types exposing (FrontendModel, FrontendMsg(..))


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
            List.filter (\cell -> cell.index <= index) model.cellList
                |> List.map (\cell -> { cell | cellState = CSView })

        suffix =
            List.filter (\cell -> cell.index > index) model.cellList
                |> List.map (\cell -> { cell | index = cell.index + 1 })
                |> List.map (\cell -> { cell | cellState = CSView })
    in
    ( { model
        | cellContent = ""
        , cellList = prefix ++ (newCell :: suffix)
      }
    , Cmd.none
    )


editCell : FrontendModel -> Int -> ( FrontendModel, Cmd FrontendMsg )
editCell model index =
    case List.Extra.getAt index model.cellList of
        Nothing ->
            ( model, Cmd.none )

        Just cell_ ->
            let
                updatedCell =
                    { cell_ | cellState = CSEdit }

                prefix =
                    List.filter (\cell -> cell.index < index) model.cellList
                        |> List.map (\cell -> { cell | cellState = CSView })

                suffix =
                    List.filter (\cell -> cell.index > index) model.cellList
                        |> List.map (\cell -> { cell | cellState = CSView })
            in
            ( { model | cellContent = cell_.text |> String.join "\n", cellList = prefix ++ (updatedCell :: suffix) }, Cmd.none )


clearCell : FrontendModel -> Int -> ( FrontendModel, Cmd FrontendMsg )
clearCell model index =
    case List.Extra.getAt index model.cellList of
        Nothing ->
            ( model, Cmd.none )

        Just cell_ ->
            let
                updatedCell =
                    { cell_ | text = [ "" ] }

                prefix =
                    List.filter (\cell -> cell.index < index) model.cellList
                        |> List.map (\cell -> { cell | cellState = CSView })

                suffix =
                    List.filter (\cell -> cell.index > index) model.cellList
                        |> List.map (\cell -> { cell | cellState = CSView })
            in
            ( { model | cellContent = "", cellList = prefix ++ (updatedCell :: suffix) }, Cmd.none )


evalCell : FrontendModel -> Int -> ( FrontendModel, Cmd FrontendMsg )
evalCell model index =
    case List.Extra.getAt index model.cellList of
        Nothing ->
            ( model, Cmd.none )

        Just cell_ ->
            let
                updatedCell =
                    LiveBook.Cell.evaluate model.cellContent cell_

                prefix =
                    List.filter (\cell -> cell.index < index) model.cellList
                        |> List.map (\cell -> { cell | cellState = CSView })

                suffix =
                    List.filter (\cell -> cell.index > index) model.cellList

                --|> List.map LiveBook.Cell.evaluate
            in
            ( { model | cellList = prefix ++ (updatedCell :: suffix) }, Cmd.none )
