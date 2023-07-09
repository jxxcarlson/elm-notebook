module LiveBook.Cell exposing (evalCell)

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


evaluateWithCumulativeBindings : FrontendModel -> Int -> Cell -> FrontendModel
evaluateWithCumulativeBindings model index cell_ =
    let
        updatedCell =
            LiveBook.Eval.evaluateWithCumulativeBindings model.kvDict model.currentBook.cells cell_
    in
    { model | currentBook = LiveBook.CellHelper.updateBook updatedCell model.currentBook }


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
                    LiveBook.CellHelper.updateBook updatedCell model.currentBook
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
    , "evalSvg"
    ]


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
            updateHead model commandWords cell_

        Just "eval" ->
            updateEval model commandWords cell_

        Just "info" ->
            updateInfo model commandWords cell_

        Just "image" ->
            { cell_ | cellState = CSView, value = CVVisual VTImage (List.drop 1 commandWords) }

        Just "svg" ->
            updateSVG model cell_

        Just "evalSvg" ->
            evalSvg model cell_

        Just "chart" ->
            { cell_ | cellState = CSView, value = CVVisual VTChart (List.drop 1 commandWords) }

        Just "plot2D" ->
            { cell_ | cellState = CSView, value = CVVisual VTPlot2D (List.drop 1 commandWords) }

        Just "readinto" ->
            { cell_ | cellState = CSView, value = CVString "*......*" }

        Just "import" ->
            { cell_ | cellState = CSView, value = CVString "*......*" }

        Just "export" ->
            updateExport commandWords cell_

        Just "correlation" ->
            updateCorrelation model commandWords cell_

        _ ->
            { cell_ | cellState = CSView, value = CVString "Could not parse data (1)" }



-- UPDATE HELPES


updateEval : FrontendModel -> List String -> Cell -> Cell
updateEval model commandWords cell_ =
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


updateHead : FrontendModel -> List String -> Cell -> Cell
updateHead model commandWords cell_ =
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


updateInfo : FrontendModel -> List String -> Cell -> Cell
updateInfo model commandWords cell_ =
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


updateSVG : FrontendModel -> Cell -> Cell
updateSVG model cell_ =
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

        isSVG str =
            let
                firstWord =
                    str |> String.replace "> svg" "" |> String.words |> List.head |> Maybe.withDefault "--xx--"
            in
            List.member firstWord [ "f", "circle", "square", "rectangle" ]

        simpleValue =
            List.head cell_.text
                |> Maybe.withDefault ""
                |> String.replace "> svg " ""
                |> String.split ","
    in
    { cell_
        | cellState = CSView
        , value =
            if isSVG (cell_.text |> List.head |> Maybe.withDefault "--x--") then
                CVVisual VTSvg simpleValue

            else
                CVVisual VTSvg value_
    }


evalSvg : FrontendModel -> Cell -> Cell
evalSvg model cell_ =
    let
        updatedCell =
            LiveBook.Eval.evaluateWithCumulativeBindings_ model.kvDict model.currentBook.cells cell_

        bindingString =
            updatedCell.bindings |> String.join "\n"

        exprString =
            updatedCell.expression
                |> String.replace "evalSvg " ""

        stringToEvaluate =
            [ "let", bindingString, "in", exprString ] |> String.join "\n"

        value_ =
            LiveBook.Eval.evaluateString stringToEvaluate
                |> String.dropLeft 1
                |> String.dropRight 1
                |> String.split ","
                |> List.map
                    (\s ->
                        if String.contains "\"" s then
                            (String.trim >> unquote) s

                        else
                            s
                    )

        unquote str =
            str |> String.dropLeft 1 |> String.dropRight 1
    in
    { cell_
        | cellState = CSView
        , value =
            CVVisual VTSvg value_
    }


updateExport : List String -> Cell -> Cell
updateExport commandWords cell_ =
    let
        file =
            (List.Extra.getAt 1 commandWords |> Maybe.withDefault "???" |> String.replace "." "-") ++ ".csv"
    in
    { cell_ | cellState = CSView, value = CVString ("Exported data to file " ++ file) }


updateCorrelation : FrontendModel -> List String -> Cell -> Cell
updateCorrelation model commandWords cell_ =
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
