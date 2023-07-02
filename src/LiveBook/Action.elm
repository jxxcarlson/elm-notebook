module LiveBook.Action exposing (importData, readData)

import Dict
import LiveBook.DataSet
import LiveBook.Update
import Types


readData : Int -> String -> String -> String -> Types.FrontendModel -> Types.FrontendModel
readData index fileName variable dataString model =
    let
        updatedCellText =
            [ "readinto " ++ variable
            , "#"
            , "# "
                ++ (String.length dataString |> String.fromInt)
                ++ " characters, "
                ++ (dataString |> String.lines |> List.length |> String.fromInt)
                ++ " lines"
            , "# read from file `" ++ fileName ++ "`"
            , "#  and stored in variable `" ++ variable ++ "`"
            , "#"
            , "#"
            ]
                |> String.join "\n"
    in
    { model | kvDict = Dict.insert variable (quote dataString) model.kvDict, pressedKeys = [] }
        |> (\model_ -> LiveBook.Update.updateCellText model_ index updatedCellText)


importData : Int -> String -> LiveBook.DataSet.DataSet -> Types.FrontendModel -> Types.FrontendModel
importData index variable dataset model =
    let
        updatedCellText =
            [ "import " ++ dataset.identifier ++ " as " ++ variable
            , "#"
            , "# "
                ++ (String.length dataset.data |> String.fromInt)
                ++ " characters, "
                ++ (dataset.data |> String.lines |> List.length |> String.fromInt)
                ++ " lines"
            , "#"
            , "#"
            ]
                |> String.join "\n"
    in
    { model | kvDict = Dict.insert variable (quote dataset.data) model.kvDict, pressedKeys = [] }
        |> (\model_ -> LiveBook.Update.updateCellText model_ index updatedCellText)


quote str =
    "\"" ++ str ++ "\""
