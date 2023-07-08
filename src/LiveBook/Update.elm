module LiveBook.Update exposing
    ( clearCell
    , clearNotebookValues
    , deleteCell
    , editCell
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
import LiveBook.CellHelper
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
import Types exposing (FrontendModel, FrontendMsg(..))


clearNotebookValues : Book -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
clearNotebookValues book model =
    let
        newBook =
            { book | cells = List.map (\cell -> { cell | value = CVNone }) book.cells }
    in
    ( { model | currentBook = newBook }, Lamdera.sendToBackend (Types.SaveNotebook newBook) )



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
                    LiveBook.CellHelper.updateBook updatedCell model.currentBook
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
                    LiveBook.CellHelper.updateBook updatedCell model.currentBook
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
            LiveBook.CellHelper.addCellToBook newCell model.currentBook

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
            { model | currentBook = LiveBook.CellHelper.updateBook { cell_ | value = cellValue } model.currentBook }


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
            { model | cellContent = str, currentBook = LiveBook.CellHelper.updateBook updatedCell model.currentBook }


toggleCellLock : Cell -> FrontendModel -> FrontendModel
toggleCellLock cell model =
    let
        updatedCell =
            { cell | locked = not cell.locked }

        updatedBook =
            LiveBook.CellHelper.updateBook updatedCell model.currentBook
    in
    { model | currentBook = updatedBook }



--foo = ["\"circle 400 300 10 blue\""," \"circle 216.09284709235476 245.59788891106302 10 blue\""," \"circle 340.8082061813392 391.2945250727628 10 blue\""," \"circle 315.4251449887584 201.1968375907138 10 blue\""," \"circle 233.3061938347738 374.5113160479349 10 blue\""," \"circle 396.49660284921134 273.76251462960715 10 blue\""," \"circle 204.75870195848438 269.51893788977833 10 blue\""," \"circle 363.33192030863 377.3890681557889 10 blue\""," \"circle 288.96127561609524 200.61113460766248 10 blue\""," \"circle 255.19263838708298 389.3996663600558 10 blue\""," \"circle 386.2318872287684 249.36343588902412 10 blue\""," \"circle 200.09791866853521 295.5757321914929 10 blue\""," \"circle 381.4180970526562 358.0611184212314 10 blue\""," \"circle 263.27086695453033 206.98940498132382 10 blue\""," \"circle 280.2186425995732 398.02396594403115 10 blue\""," \"circle 369.9250806478375 228.51235703708352 10 blue\""," \"circle 202.43706872047625 321.94252583790046 10 blue\""," \"circle 393.7994752119441 334.664945549703 10 blue\""," \"circle 240.1539930942142 219.88473642661694 10 blue\""," \"circle 306.6306858351711 399.77992786806004 10 blue\""," \"circle 348.7187675007006 212.67027027860053 10 blue\""," \"circle 211.6122526817628 346.7718518342759 10 blue\""]
