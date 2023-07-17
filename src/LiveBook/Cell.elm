module LiveBook.Cell exposing (evalCell)

import Dict exposing (Dict)
import Eval
import File.Select
import Lamdera
import List.Extra
import LiveBook.CellHelper
import LiveBook.Eval
import LiveBook.Function
import LiveBook.Parser
import LiveBook.State
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
import Value exposing (Value(..))



-- EVALCELL


{-|

    evalCell is called when (a) the user presses enter in a cell and
    also (b) when the message EvalCell is received.
    At the moment (b) never happens.  TODO: do we really need (b)?

    NOTE: evalCell makes one of two possible calls:
    (a) to evaluateWithCumulativeBindings or
    (b) to executeCell.  Branch (b) is taken when
    there is an alternate evaluation strategy (and also if the
    cell contains a command).

-}
evalCell : Int -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
evalCell index model =
    case List.Extra.getAt index model.currentBook.cells of
        Nothing ->
            ( model, Cmd.none )

        Just cell_ ->
            let
                command : Maybe String
                command =
                    commandFromCell cell_
            in
            if command == Just "use:" then
                handleUseCmd model cell_

            else if List.member command (List.map Just ("setValue" :: commands)) then
                executeCell cell_ model

            else
                ( evaluateWithCumulativeBindings model cell_, Cmd.none )


{-|

    This is the "normal" evaluation strategy.  Elm code in the cell is evaluated,
    the result is stored in the cell, and the current notebook is updated.

-}
evaluateWithCumulativeBindings : FrontendModel -> Cell -> FrontendModel
evaluateWithCumulativeBindings model cell_ =
    let
        updatedCell =
            LiveBook.Eval.evaluateWithCumulativeBindings model.state model.valueDict model.kvDict model.currentBook.cells cell_
    in
    { model | currentBook = LiveBook.CellHelper.updateBook updatedCell model.currentBook }


{-|

    Function executeCell is called when the user presses enter in a cell.
    As a result, the contents of that cell are updated and (optionally)
    a command is run.  The FrontendModel is updated only insofar as
    the given cell is affected or the command is run.

-}
executeCell : Cell -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
executeCell cell_ model =
    let
        ( stringToEvaluate, bindings ) =
            LiveBook.Eval.evaluateWithCumulativeBindingsCore model.state model.valueDict model.kvDict model.currentBook.cells cell_

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
            getCommand cell_ commandWords

        commandWords =
            -- run a the command defined in the cell
            getCommandWords cell_

        newBook =
            LiveBook.CellHelper.updateBook updatedCell model.currentBook
    in
    ( { model | currentBook = newBook } |> setValue { cell_ | bindings = bindings } commandWords, cmd )



--- BEGIN HANDLERS ---


handleUseCmd model cell_ =
    let
        bindings_ =
            LiveBook.Eval.getPriorBindings cell_.index model.currentBook.cells

        newBook =
            LiveBook.CellHelper.updateBook { cell_ | cellState = CSView } model.currentBook

        getExpression : String -> String
        getExpression str =
            str |> String.split "=" |> List.drop 1 |> String.join ""
    in
    case List.Extra.unconsLast bindings_ of
        Nothing ->
            ( { model | currentBook = newBook }, Cmd.none )

        Just ( nextStateFunctionText, bindings ) ->
            let
                n =
                    List.length bindings

                scopedBindings =
                    List.drop (n - 1) bindings
            in
            ( { model
                | nextStateRecord =
                    Just { expression = nextStateFunctionText |> getExpression, bindings = scopedBindings }
                , currentBook = newBook
              }
            , Cmd.none
            )


commandFromCell : Cell -> Maybe String
commandFromCell cell =
    cell.text
        |> List.head
        |> Maybe.withDefault ""
        |> String.replace ">" ""
        |> String.words
        |> List.map String.trim
        |> List.head


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
    , "timeSeries"
    , "use:"
    , "svg"
    , "evalSvg"
    ]


specialCommands =
    [ "setValue"
    ]


getCommand : Cell -> List String -> Cmd FrontendMsg
getCommand cell_ commandWords =
    case List.head commandWords of
        Nothing ->
            Cmd.none

        Just "readinto" ->
            case List.Extra.getAt 1 commandWords of
                Nothing ->
                    Cmd.none

                Just variable ->
                    File.Select.file [ "text/csv" ] (StringDataSelected cell_.index variable)

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
            handleHeadCmd model commandWords cell_

        Just "use:" ->
            handleNextStateFunction model cell_

        Just "info" ->
            handleInfoCmd model commandWords cell_

        Just "image" ->
            { cell_ | cellState = CSView, value = CVVisual VTImage (List.drop 1 commandWords) }

        Just "svg" ->
            svgHandler model cell_

        Just "evalSvg" ->
            evalSvgHandler model cell_

        Just "chart" ->
            { cell_ | cellState = CSView, value = CVVisual VTChart (List.drop 1 commandWords) }

        Just "timeSeries" ->
            let
                maybeValue =
                    LiveBook.Eval.getPriorBindings cell_.index model.currentBook.cells
                        |> List.map (String.split "=" >> List.map String.trim)
                        |> List.map twoListToPair
                        |> List.filterMap identity
                        |> List.Extra.find (\( a, b ) -> a == "data")
                        |> Maybe.map Tuple.second
                        |> Maybe.withDefault ""
                        |> LiveBook.Eval.evaluateWordsWithState model.state
                        |> unquote
                        |> Eval.eval
                        |> Result.toMaybe

                valueList : List ( Float, Float )
                valueList =
                    case maybeValue of
                        Nothing ->
                            []

                        Just (List floatList) ->
                            floatList
                                |> List.map LiveBook.Parser.unwrapFloat
                                |> List.filterMap identity
                                |> List.indexedMap (\k v -> ( toFloat k, v ))

                        Just _ ->
                            []
            in
            { cell_ | cellState = CSView, value = CVPlot2D commandWords valueList }

        Just "plot2D" ->
            let
                ( exprString, bindings ) =
                    LiveBook.Eval.evaluateWithCumulativeBindingsCore model.state
                        model.valueDict
                        model.kvDict
                        model.currentBook.cells
                        { cell_ | text = [ "> data" ] }

                valueList1 =
                    case Eval.eval (String.replace "plot2D line " "" exprString) of
                        Err _ ->
                            []

                        Ok value ->
                            case value of
                                List valueList_ ->
                                    LiveBook.Parser.unwrapListTupleFloat valueList_

                                _ ->
                                    []

                maybeValue : Maybe Value.Value
                maybeValue =
                    LiveBook.Eval.getPriorBindings cell_.index model.currentBook.cells
                        |> List.map (String.split "=" >> List.map String.trim)
                        |> List.map twoListToPair
                        |> List.filterMap identity
                        |> List.Extra.find (\( a, b ) -> a == "data")
                        |> Maybe.map Tuple.second
                        |> Maybe.withDefault ""
                        |> LiveBook.Eval.evaluateWordsWithState model.state
                        |> unquote
                        |> Eval.eval
                        |> Result.toMaybe

                valueList2 : List ( Float, Float )
                valueList2 =
                    case maybeValue of
                        Nothing ->
                            []

                        Just (List floatList) ->
                            floatList |> LiveBook.Parser.unwrapListTupleFloat

                        Just _ ->
                            []

                valueList =
                    if List.isEmpty valueList1 then
                        valueList2

                    else
                        valueList1
            in
            { cell_ | cellState = CSView, value = CVPlot2D commandWords valueList }

        Just "readinto" ->
            { cell_ | cellState = CSView, value = CVString "*......*" }

        Just "import" ->
            { cell_ | cellState = CSView, value = CVString "*......*" }

        Just "export" ->
            exportDataHandler commandWords cell_

        Just "correlation" ->
            correlationHandler model commandWords cell_

        Just "setValue" ->
            { cell_ | cellState = CSView, value = CVString "Value set" }

        _ ->
            { cell_ | cellState = CSView, value = CVString "Could not parse data (1)" }



-- UPDATE HELPERS


handleNextStateFunction : FrontendModel -> Cell -> Cell
handleNextStateFunction model cell_ =
    let
        parts =
            cell_.text
                |> String.join "\n"
                |> String.replace "> use:" ""
                |> String.trim
                -- drop "[
                -- drop ]"
                |> String.split ";"
                |> List.map String.trim
    in
    { cell_
        | cellState = CSView
        , bindings = LiveBook.Eval.getPriorBindings cell_.index model.currentBook.cells
    }


handleHeadCmd : FrontendModel -> List String -> Cell -> Cell
handleHeadCmd model commandWords cell_ =
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


handleInfoCmd : FrontendModel -> List String -> Cell -> Cell
handleInfoCmd model commandWords cell_ =
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


svgHandler : FrontendModel -> Cell -> Cell
svgHandler model cell_ =
    let
        updatedCell =
            LiveBook.Eval.evaluateWithCumulativeBindings model.state model.valueDict model.kvDict model.currentBook.cells cell_

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

        isSVG str =
            let
                firstWord =
                    str |> String.replace "> svg" "" |> String.words |> List.head |> Maybe.withDefault "--xx--"
            in
            List.member firstWord [ "line", "f", "circle", "square", "rectangle" ]

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


evalSvgHandler : FrontendModel -> Cell -> Cell
evalSvgHandler model cell_ =
    let
        updatedCell =
            LiveBook.Eval.evaluateWithCumulativeBindings model.state model.valueDict model.kvDict model.currentBook.cells cell_

        bindingString =
            updatedCell.bindings
                |> String.join "\n"

        exprString =
            updatedCell.expression
                |> String.replace "evalSvg " ""

        stringToEvaluate =
            [ "let", bindingString, "in", exprString ]
                |> String.join "\n"
                |> String.replace "ticks" (String.fromInt model.tickCount)
                |> String.replace "prob0" (String.fromFloat (List.Extra.getAt 0 model.randomProbabilities |> Maybe.withDefault 0))
                |> String.replace "prob1" (String.fromFloat (List.Extra.getAt 1 model.randomProbabilities |> Maybe.withDefault 0))
                |> String.replace "prob2" (String.fromFloat (List.Extra.getAt 2 model.randomProbabilities |> Maybe.withDefault 0))
                |> String.replace "prob3" (String.fromFloat (List.Extra.getAt 3 model.randomProbabilities |> Maybe.withDefault 0))

        value_ : List String
        value_ =
            LiveBook.Eval.evaluateString stringToEvaluate
                |> String.split ","
                |> List.map (\s -> (String.trim >> unquote >> fix) s)
                |> Debug.log "@@ VALUE"

        fix str =
            str |> String.replace "[" "" |> String.replace "]" ""
    in
    { cell_
        | cellState = CSView
        , value =
            CVVisual VTSvg value_
    }


exportDataHandler : List String -> Cell -> Cell
exportDataHandler commandWords cell_ =
    let
        file =
            (List.Extra.getAt 1 commandWords |> Maybe.withDefault "???" |> String.replace "." "-") ++ ".csv"
    in
    { cell_ | cellState = CSView, value = CVString ("Exported data to file " ++ file) }


correlationHandler : FrontendModel -> List String -> Cell -> Cell
correlationHandler model commandWords cell_ =
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



-- HELPER


{-|

    This function is used via the syntax `setValue name value` in a cell
    to set the value of a variable in the model.valueDict

-}
setValue : Cell -> List String -> Types.FrontendModel -> Types.FrontendModel
setValue cell commandWords_ model =
    case commandWords_ of
        "setValue" :: name :: tail ->
            let
                value : Maybe Value.Value
                value =
                    tail
                        |> List.map (LiveBook.Eval.transformWordWithValueDict model.valueDict)
                        |> String.join " "
                        |> LiveBook.Eval.evaluateStringWithBindings cell.bindings
                        |> LiveBook.Parser.parse

                valueDict =
                    case value of
                        Nothing ->
                            model.valueDict

                        Just value_ ->
                            Dict.insert name value_ model.valueDict
            in
            { model
                | valueDict = valueDict
            }

        _ ->
            model


setValueFromFloats : Cell -> List Float -> FrontendModel -> FrontendModel
setValueFromFloats cell floats model =
    setValue cell (List.map String.fromFloat floats) model


unquote : String -> String
unquote str =
    String.replace "\"" "" str


twoListToPair : List a -> Maybe ( a, a )
twoListToPair list =
    case list of
        [ x, y ] ->
            Just ( x, y )

        _ ->
            Nothing
