module LiveBook.Update exposing
    ( clearCell
    , clearNotebookValues
    , deleteCell
    , editCell
    , evalCell
    , executeCell_
    , makeNewCell
    , setCellValue
    , toggleCellLock
    , updateCellText
    )

{-|

    In module LiveBook.Udate, we implement functions such as

        - chart
        - image
        - readInto
        - import
        - export
        - correlation

New commans appear in two places:

        - in the list of commands
        - in the case statement in executeCell_

-}

import Dict
import File.Select
import Lamdera
import List.Extra
import LiveBook.Eval
import LiveBook.Function
import LiveBook.Types
    exposing
        ( Book
        , Cell
        , CellState(..)
        , CellValue(..)
        , VisualType(..)
        )
import Maybe.Extra
import Stat
import Types exposing (FrontendModel, FrontendMsg(..))


executeCell_ : Int -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
executeCell_ index model =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            ( model, Cmd.none )

        Just cell_ ->
            let
                updatedCell =
                    -- Update the cell according to
                    -- (a) the expression (if any) in the cell
                    -- (b) the command (if any) in the cell
                    --
                    -- Regarding (b), it may happen that the command
                    -- is executed as the result of
                    -- (c) running an Elm command (see 'cmd' below)
                    updateCell model commandWords cell_

                cmd =
                    getCommand index cell_ commandWords

                commandWords =
                    -- run a the command defined in the cell
                    getCommandWords cell_

                newBook =
                    updateBook updatedCell model.currentBook
            in
            ( { model | currentBook = newBook }, cmd )


commands =
    [ "chart", "readinto", "image", "import", "export", "correlation", "info", "head", "plot2D", "eval" ]


clearNotebookValues : Book -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
clearNotebookValues book model =
    let
        newBook =
            { book | cells = List.map (\cell -> { cell | value = CVNone }) book.cells }
    in
    ( { model | currentBook = newBook }, Lamdera.sendToBackend (Types.SaveNotebook newBook) )


getCommand : Int -> Cell -> List String -> Cmd FrontendMsg
getCommand index cell_ commandWords =
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

        Just "export" ->
            case commandWords of
                "export" :: identifier :: _ ->
                    Lamdera.sendToBackend (Types.GetDataSetForDownload identifier)

                _ ->
                    Cmd.none

        _ ->
            Cmd.none


getCommandWords : Cell -> List String
getCommandWords cell_ =
    cell_.text
        |> List.filter (\line -> not <| String.startsWith "#" line)
        |> String.join "\n"
        |> String.replace ">" ""
        |> String.trim
        |> String.words


updateCell : FrontendModel -> List String -> Cell -> Cell
updateCell model commandWords cell_ =
    case List.head commandWords of
        Nothing ->
            { cell_ | cellState = CSView }

        Just "head" ->
            let
                n : Maybe Int
                n =
                    List.Extra.getAt 1 commandWords |> Maybe.andThen String.toInt

                identifier_ =
                    case n of
                        Nothing ->
                            List.Extra.getAt 1 commandWords |> Maybe.withDefault "_nothing_"

                        Just _ ->
                            List.Extra.getAt 2 commandWords |> Maybe.withDefault "_nothing_"

                message =
                    case Dict.get identifier_ model.kvDict of
                        Just data_ ->
                            data_
                                |> String.lines
                                |> List.take (n |> Maybe.withDefault 1)
                                |> String.join " \\\n"

                        Nothing ->
                            "Could not find data with identifier " ++ identifier_ ++ " in the notebook."
            in
            { cell_ | cellState = CSView, value = CVString message }

        Just "eval" ->
            let
                identifier : String
                identifier =
                    List.Extra.getAt 1 commandWords |> Maybe.withDefault "???"
            in
            { cell_
                | cellState = CSView
                , text = Dict.get identifier model.kvDict |> Maybe.withDefault "???" |> String.lines
                , value = CVString (Dict.get identifier model.kvDict |> Maybe.withDefault "---")
            }

        Just "info" ->
            let
                identifier : String
                identifier =
                    List.Extra.getAt 1 commandWords |> Maybe.withDefault "---"

                maybeDataSetMetadata =
                    List.Extra.find (\dataSet -> String.contains identifier dataSet.identifier)
                        (model.publicDataSetMetaDataList ++ model.privateDataSetMetaDataList)
            in
            case maybeDataSetMetadata of
                Nothing ->
                    { cell_ | cellState = CSView, value = CVString "Nothing found" }

                Just dataSetMetadata ->
                    let
                        text =
                            dataSetMetadata.name
                                ++ "\n"
                                ++ dataSetMetadata.identifier
                                ++ "\n\n"
                                ++ dataSetMetadata.description
                                ++ "\n\n"
                                ++ dataSetMetadata.comments
                    in
                    { cell_ | cellState = CSView, value = CVString text }

        Just "image" ->
            { cell_ | cellState = CSView, value = CVVisual VTImage (List.drop 1 commandWords) }

        Just "chart" ->
            { cell_ | cellState = CSView, value = CVVisual VTChart (List.drop 1 commandWords) }

        Just "plot2D" ->
            { cell_ | cellState = CSView, value = CVVisual VTPlot2D (List.drop 1 commandWords) }

        Just "readinto" ->
            { cell_ | cellState = CSView, value = CVString "*......*" }

        Just "import" ->
            { cell_ | cellState = CSView, value = CVString "*......*" }

        Just "export" ->
            let
                file =
                    (List.Extra.getAt 1 commandWords |> Maybe.withDefault "???" |> String.replace "." "-") ++ ".csv"
            in
            { cell_ | cellState = CSView, value = CVString ("Exported data to file " ++ file) }

        Just "correlation" ->
            -- correlation column1 column2 identifier
            case commandWords of
                "correlation" :: column1 :: column2 :: identifier :: _ ->
                    case
                        ( String.toInt column1
                        , String.toInt column2
                        , Dict.get identifier model.kvDict
                        )
                    of
                        ( Just column1_, Just column2_, Just data ) ->
                            let
                                maybeValue : Maybe Float
                                maybeValue =
                                    LiveBook.Function.wrangleToListFloatPair (Just [ column1_, column2_ ]) data
                                        |> Maybe.andThen Stat.correlation
                            in
                            case maybeValue of
                                Just corr ->
                                    { cell_
                                        | cellState = CSView
                                        , value = CVString (String.fromFloat (LiveBook.Function.roundTo 3 corr))
                                    }

                                _ ->
                                    { cell_ | cellState = CSView, value = CVString "Could not parse data (4)" }

                        _ ->
                            { cell_ | cellState = CSView, value = CVString "Could not parse data (3)" }

                _ ->
                    { cell_ | cellState = CSView, value = CVString "Could not parse data (2)" }

        _ ->
            { cell_ | cellState = CSView, value = CVString "Could not parse data (1)" }


makeNewCell : FrontendModel -> Int -> ( FrontendModel, Cmd FrontendMsg )
makeNewCell model index =
    let
        newCell =
            { index = index + 1
            , text = [ "# New cell (" ++ String.fromInt (index + 2) ++ ") ", "-- code --" ]
            , value = CVNone
            , cellState = CSEdit
            , locked = False
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


toggleCellLock : Cell -> FrontendModel -> FrontendModel
toggleCellLock cell model =
    let
        updatedCell =
            { cell | locked = not cell.locked }

        updatedBook =
            updateBook updatedCell model.currentBook
    in
    { model | currentBook = updatedBook }


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
