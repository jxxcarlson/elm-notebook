module LiveBook.Action exposing (readData)

import Dict
import LiveBook.Update
import Types


readData : Int -> String -> String -> String -> Types.FrontendModel -> Types.FrontendModel
readData index fileName variable dataString model =
    let
        quote str =
            "\"" ++ str ++ "\""

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
