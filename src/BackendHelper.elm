module BackendHelper exposing (..)

-- HELPERS

import Notebook.Book exposing (Book)
import NotebookDict
import Random
import Types exposing (..)
import UUID


type alias Model =
    BackendModel


getUUID : Model -> Model
getUUID model =
    let
        ( uuid, seed ) =
            model.randomSeed |> Random.step UUID.generator
    in
    { model | uuid = UUID.toString uuid, randomSeed = seed }


compress : String -> String
compress str =
    str |> String.toLower |> String.replace " " "-"


addScratchPadToUser : String -> Model -> ( Model, Book )
addScratchPadToUser username model =
    let
        newModel =
            getUUID model

        rawScratchpad =
            Notebook.Book.scratchPad username

        scratchPad : Book
        scratchPad =
            { rawScratchpad
                | id = newModel.uuid
                , title = "Scratchpad"
                , slug = compress (username ++ ".scratchpad")
                , createdAt = model.currentTime
                , updatedAt = model.currentTime
            }

        oldUserToNoteBookDict =
            model.userToNoteBookDict

        newUserToNoteBookDict =
            NotebookDict.insert username newModel.uuid scratchPad oldUserToNoteBookDict
    in
    ( { newModel | userToNoteBookDict = newUserToNoteBookDict }, scratchPad )
