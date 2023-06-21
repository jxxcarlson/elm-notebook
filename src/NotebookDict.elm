module NotebookDict exposing
    ( NotebookDataError(..)
    , all
    , insert
    , lookup
    , remove
    )

import Dict
import List.Extra
import Types exposing(Book)

type NotebookDataError
    = NotebookOwnerNotFound String
    | NotebookNotFound String



--makeReverseDict : Dict.Dict String Types.ImageRecord -> Dict.Dict String String
--makeReverseDict dict =
--    dict
--        |> Dict.toList
--        |> List.map (\( key, record ) -> ( record.urlList |> List.head |> Maybe.withDefault "nothing", key ))
--        |> List.filter (\( key, _ ) -> key /= "nothing")
--        |> Dict.fromList


remove : Types.Username -> String -> Types.UserToNoteBookDict -> Types.UserToNoteBookDict
remove username_ identifier userToNoteBookDict =
    case Dict.get username_ userToNoteBookDict of
        Nothing ->
            userToNoteBookDict

        Just notebookDict ->
            Dict.insert username_ (Dict.remove identifier notebookDict) userToNoteBookDict


{-|

    Find a notebook by username and identifier.

-}
lookup : Types.Username -> String -> Types.UserToNoteBookDict -> Result NotebookDataError Book
lookup username_ identifier userToNotbookDict =
    case Dict.get username_ userToNotbookDict of
        Nothing ->
            Err (NotebookOwnerNotFound username_)

        Just notebookDict ->
            case Dict.get identifier notebookDict of
                Nothing ->
                    Err (NotebookNotFound identifier)

                Just book ->
                    Ok book



--find : Types.Username -> String -> Types.ImageUserDict -> Maybe Types.ImageRecord


{-|

    Return all notebooks belonging to a user.

-}
all : Types.Username -> Types.UserToNoteBookDict -> List Book
all username_ dict =
    case Dict.get username_ dict of
        Nothing ->
            []

        Just imageDict ->
            Dict.values imageDict


{-|

    Insert a notebook for a user into the master dictionary.

-}
insert : Types.Username -> String -> Book -> Types.UserToNoteBookDict -> Types.UserToNoteBookDict
insert username_ identifier notebook userToNotebookDict =
    case Dict.get username_ userToNotebookDict of
        Nothing ->
            userToNotebookDict

        Just notebookDict ->
            Dict.insert username_ (Dict.insert identifier notebook notebookDict) userToNotebookDict



--
--publicDict : Types.ImageUserDict -> Types.ImageDict
--publicDict dictV2 =
--    let
--        folder3 : Types.ImageRecord -> Types.ImageDict -> Types.ImageDict
--        folder3 record dict_ =
--            if record.public then
--                Dict.insert record.identifier record dict_
--
--            else
--                dict_
--
--        records : List Types.ImageRecord
--        records =
--            Dict.values dictV2
--                |> List.map (\dict_ -> Dict.values dict_)
--                |> List.concat
--    in
--    List.foldl folder3 Dict.empty records
--
--
--updatePublicRecords : Types.ImageUserDict -> Types.ImageUserDict
--updatePublicRecords dict =
--    Dict.insert "public" (publicDict dict) dict
