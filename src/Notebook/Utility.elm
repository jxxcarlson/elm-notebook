module Notebook.Utility exposing (..)

import Dict exposing (Dict)
import List.Extra
import Maybe.Extra
import Regex exposing (Regex)


{-| Copilot almost wrote this
-}
getChunks : List String -> List (List String)
getChunks lines =
    (getChunks_ { input = lines, output = [] }).output |> List.filter (\chnk -> chnk /= [])


{-|

    > lines1
    ["> a = 1","> b = 1","> f n = ","  if n == 0 then 1 else n * f (n - 1)"]
        : List String
    > getChunks lines1
    [["> a = 1"],["> b = 1"],["> f n = ","  if n == 0 then 1 else n * f (n - 1)"]]


    > lines2
    ["> a = 1","> b = 1","","> f n = ","  if n == 0 then 1 else n * f (n - 1)"]
        : List String
    > getChunks lines2
    [["> a = 1"],["> b = 1",""],["> f n = ","  if n == 0 then 1 else n * f (n - 1)"]]

-}
getChunks_ : { input : List String, output : List (List String) } -> { input : List String, output : List (List String) }
getChunks_ { input, output } =
    if input == [] then
        { input = [], output = output }

    else
        let
            chunk_ =
                chunk input

            rest =
                List.drop (List.length chunk_) input
        in
        getChunks_ { input = rest, output = output ++ [ chunk_ ] }


chunk : List String -> List String
chunk lines_ =
    case List.Extra.uncons lines_ of
        Nothing ->
            []

        Just ( line, rest ) ->
            if String.left 2 line == "> " then
                String.trim (String.dropLeft 2 line) :: List.Extra.takeWhile (\l -> String.left 2 l /= "> ") rest

            else
                -- Use an error recovery hack (TODO: very bad!!)
                chunk (("> " ++ line) :: rest)


removeLeadingCaret : String -> String
removeLeadingCaret string =
    if String.left 2 string == "> " then
        String.dropLeft 2 string

    else
        string


keyValueDict : List String -> Dict String String
keyValueDict strings_ =
    List.map (String.split ":") strings_
        |> List.map (List.map String.trim)
        |> List.map pairFromList
        |> Maybe.Extra.values
        |> Dict.fromList


pairFromList : List String -> Maybe ( String, String )
pairFromList strings =
    case strings of
        [ x, y ] ->
            Just ( x, y )

        _ ->
            Nothing


compressWhitespace : String -> String
compressWhitespace string =
    userReplace "\\s\\s+" (\_ -> " ") string


slugify : String -> String
slugify str =
    str
        |> removeNonAlphaNum
        |> compressWhitespace
        |> String.replace " " "-"
        |> String.toLower


removeNonAlphaNum : String -> String
removeNonAlphaNum string =
    userReplace "[^A-Za-z0-9\\-]" (\_ -> "") string


userReplace : String -> (Regex.Match -> String) -> String -> String
userReplace userRegex replacer string =
    case Regex.fromString userRegex of
        Nothing ->
            string

        Just regex ->
            Regex.replace regex replacer string
