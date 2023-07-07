module LiveBook.Update exposing
    ( clearCell
    , clearNotebookValues
    , deleteCell
    , editCell
    , evalCell
    , executeCell
    , makeNewCell
    , setCellValue
    , toggleCellLock
    , updateCellText
    )

{-|

    This module implements functions called by Frontend.update
    (see the list of functions exposed).

    All return either (a) (FrontendModel, Cmd FrontendMsg) or
    (b) Cmd FrontendMsg

    See the value 'commands' for the complete list of commands.

New commands are implemented in the case statement
of function 'executeCell'. A command will be
executed only if it also appears in the list 'commands'.

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
import Stat
import Types exposing (FrontendModel, FrontendMsg(..))



-- EVALCELL


{-|

    evalCell is called when (a) the user presses enter in a cell and
    also (b) when the message EvalCell is received.
    At the moment (b) never happens.  TODO: do we really need (b)?

    NOTE: evalCell makes one of two possible calls:
    (a) to evaluateWithCumulativeBindings or
    (b) to executeCell.  Branch (b) is taken when the cell contains a command.

-}
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
                executeCell index model

            else
                ( evaluateWithCumulativeBindings model index cell_, Cmd.none )


evaluateWithCumulativeBindings model index cell_ =
    let
        updatedCell =
            LiveBook.Eval.evaluateWithCumulativeBindings model.kvDict model.currentBook.cells cell_
    in
    { model | currentBook = updateBook updatedCell model.currentBook }


executeCell : Int -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
executeCell index model =
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
    [ "chart"
    , "readinto"
    , "image"
    , "import"
    , "export"
    , "correlation"
    , "info"
    , "head"
    , "plot2D"
    , "eval"
    , "svg"
    ]


clearNotebookValues : Book -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
clearNotebookValues book model =
    let
        newBook =
            { book | cells = List.map (\cell -> { cell | value = CVNone }) book.cells }
    in
    ( { model | currentBook = newBook }, Lamdera.sendToBackend (Types.SaveNotebook newBook) )


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
                , bindings = Dict.get identifier model.kvDict |> Maybe.withDefault "???" |> String.lines
                , value = CVNone --CVString (Dict.get identifier model.kvDict |> Maybe.withDefault "---")
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

        Just "svg" ->
            let
                updatedCell =
                    LiveBook.Eval.evaluateWithCumulativeBindings_ model.kvDict model.currentBook.cells cell_

                bindingString =
                    updatedCell.bindings |> String.join "\n"

                exprString =
                    updatedCell.expression
                        |> String.replace "svg " ""

                stringToEvaluate =
                    [ "let", bindingString, "in", exprString ] |> String.join "\n"

                value_ =
                    LiveBook.Eval.evaluateString stringToEvaluate
                        |> String.dropLeft 1
                        |> String.dropRight 1
                        |> String.split ","
                        |> List.map (String.trim >> unquote)

                unquote str =
                    str |> String.dropLeft 1 |> String.dropRight 1

                simpleValue =
                    List.head cell_.text
                        |> Maybe.withDefault ""
                        |> String.replace "> svg " ""
                        |> String.split ","
            in
            { cell_
                | cellState = CSView
                , value =
                    if cell_.bindings == [] then
                        CVVisual VTSvg simpleValue

                    else
                        CVVisual VTSvg value_
            }

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



-- OTHER TOP LEVEL FUNCTIONS


deleteCell : Int -> FrontendModel -> FrontendModel
deleteCell index model =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            model

        Just _ ->
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

                newBook =
                    updateBook updatedCell model.currentBook
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

                newBook =
                    updateBook updatedCell model.currentBook
            in
            ( { model | cellContent = "", currentBook = newBook }, Cmd.none )


makeNewCell : FrontendModel -> Int -> ( FrontendModel, Cmd FrontendMsg )
makeNewCell model index =
    let
        newCell =
            { index = index + 1
            , text = [ "# New cell (" ++ String.fromInt (index + 2) ++ ") ", "-- code --" ]
            , bindings = []
            , expression = ""
            , value = CVNone
            , cellState = CSEdit
            , locked = False
            }

        newBook =
            addCellToBook newCell model.currentBook

        _ =
            List.length newBook.cells
    in
    ( { model
        | cellContent = ""
        , currentBook = newBook
        , currentCellIndex = index + 1
      }
    , Cmd.none
    )


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


toggleCellLock : Cell -> FrontendModel -> FrontendModel
toggleCellLock cell model =
    let
        updatedCell =
            { cell | locked = not cell.locked }

        updatedBook =
            updateBook updatedCell model.currentBook
    in
    { model | currentBook = updatedBook }


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



--foo = ["\"circle 400 300 10 blue\""," \"circle 216.09284709235476 245.59788891106302 10 blue\""," \"circle 340.8082061813392 391.2945250727628 10 blue\""," \"circle 315.4251449887584 201.1968375907138 10 blue\""," \"circle 233.3061938347738 374.5113160479349 10 blue\""," \"circle 396.49660284921134 273.76251462960715 10 blue\""," \"circle 204.75870195848438 269.51893788977833 10 blue\""," \"circle 363.33192030863 377.3890681557889 10 blue\""," \"circle 288.96127561609524 200.61113460766248 10 blue\""," \"circle 255.19263838708298 389.3996663600558 10 blue\""," \"circle 386.2318872287684 249.36343588902412 10 blue\""," \"circle 200.09791866853521 295.5757321914929 10 blue\""," \"circle 381.4180970526562 358.0611184212314 10 blue\""," \"circle 263.27086695453033 206.98940498132382 10 blue\""," \"circle 280.2186425995732 398.02396594403115 10 blue\""," \"circle 369.9250806478375 228.51235703708352 10 blue\""," \"circle 202.43706872047625 321.94252583790046 10 blue\""," \"circle 393.7994752119441 334.664945549703 10 blue\""," \"circle 240.1539930942142 219.88473642661694 10 blue\""," \"circle 306.6306858351711 399.77992786806004 10 blue\""," \"circle 348.7187675007006 212.67027027860053 10 blue\""," \"circle 211.6122526817628 346.7718518342759 10 blue\""]
