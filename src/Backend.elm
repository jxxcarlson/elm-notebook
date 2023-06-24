module Backend exposing (..)

import Authentication
import Backend.Authentication
import BackendHelper
import Dict
import Env exposing (Mode(..))
import Hex
import Lamdera exposing (ClientId, SessionId, sendToFrontend)
import LiveBook.Book
import NotebookDict
import Random
import Time
import Token
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Time.every 10000 Tick
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { message = "Hello!"

      -- RANDOM
      , randomSeed = Random.initialSeed 1234
      , uuidCount = 0
      , uuid = "aldkjf;ladjkf;dalkjf;ldkjf"
      , randomAtmosphericInt = Nothing
      , currentTime = Time.millisToPosix 0

      -- NOTEBOOK
      , userToNoteBookDict = Dict.empty
      , slugDict = Dict.empty

      -- USER
      , authenticationDict = Dict.empty

      -- DOCUMENTS
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )

        Tick newTime ->
            ( { model | currentTime = newTime }, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        -- ADMIN
        RunTask ->
            ( model, Cmd.none )

        SendUsers ->
            ( model, sendToFrontend clientId (GotUsers (Authentication.users model.authenticationDict)) )

        -- USER
        UpdateUserWith user ->
            ( { model | authenticationDict = Authentication.updateUser user model.authenticationDict }, Cmd.none )

        --SignInBE username encryptedPassword ->
        --    Backend.Authentication.signIn model sessionId clientId username encryptedPassword
        SignInBEDev ->
            Backend.Authentication.signIn model sessionId clientId "localuser" (Authentication.encryptForTransit "asdfasdf")

        SignUpBE username encryptedPassword email ->
            Backend.Authentication.signUpUser model sessionId clientId username encryptedPassword email

        SignOutBE mUsername ->
            case mUsername of
                Nothing ->
                    ( model, Cmd.none )

                Just username ->
                    case Env.mode of
                        Env.Production ->
                            Backend.Authentication.signOut model username clientId

                        Env.Development ->
                            Backend.Authentication.signOut model username clientId
                                |> (\( m1, c1 ) ->
                                        let
                                            ( m2, c2 ) =
                                                -- Backend.Update.cleanup m1 sessionId clientId
                                                ( m1, c1 )
                                        in
                                        ( m2, Cmd.batch [ c1, c2 ] )
                                   )

        SignInBE username encryptedPassword ->
            case Dict.get username model.authenticationDict of
                Just userData ->
                    if Authentication.verify username encryptedPassword model.authenticationDict then
                        let
                            user =
                                userData.user

                            result =
                                NotebookDict.lookup user.username
                                    (user.currentNotebookId |> Maybe.withDefault "--xx--")
                                    model.userToNoteBookDict

                            curentBookCmd =
                                case result of
                                    Err _ ->
                                        Cmd.none

                                    Ok book ->
                                        sendToFrontend clientId (GotNotebook book)
                        in
                        ( model
                        , Cmd.batch
                            [ sendToFrontend clientId (SendUser userData.user)
                            , sendToFrontend clientId (GotNotebooks (NotebookDict.allForUser username model.userToNoteBookDict))
                            , curentBookCmd
                            ]
                        )

                    else
                        ( model, sendToFrontend clientId (SendMessage <| "Sorry, password and username don't match (1)") )

                Nothing ->
                    ( model, sendToFrontend clientId (SendMessage <| "Sorry, password and username don't match (2)") )

        -- NOTEBOOKS
        GetUsersNotebooks username ->
            ( model, sendToFrontend clientId (GotNotebooks (NotebookDict.allForUser username model.userToNoteBookDict)) )

        GetPublicNotebooks ->
            ( model, sendToFrontend clientId (GotNotebooks (NotebookDict.allPublic model.userToNoteBookDict)) )

        UpdateSlugDict book ->
            case String.split "." book.slug of
                author :: slug :: [] ->
                    let
                        oldSlugDict =
                            model.slugDict

                        newSlugDict =
                            Dict.insert book.slug { id = book.id, author = book.author, public = book.public } oldSlugDict
                    in
                    ( { model | slugDict = newSlugDict }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        GetClonedNotebook username slug ->
            case Dict.get slug model.slugDict of
                Just notebookRecord ->
                    case NotebookDict.lookup notebookRecord.author notebookRecord.id model.userToNoteBookDict of
                        Ok book ->
                            if book.public == False then
                                ( model, sendToFrontend clientId (SendMessage <| "Sorry, that notebook is private") )

                            else
                                let
                                    newModel =
                                        BackendHelper.getUUID model
                                in
                                ( newModel
                                , sendToFrontend clientId
                                    (GotNotebook
                                        { book
                                            | author = username
                                            , id = newModel.uuid
                                            , slug = BackendHelper.compress (username ++ "." ++ book.title)
                                            , origin = Just slug
                                        }
                                    )
                                )

                        Err _ ->
                            ( model, sendToFrontend clientId (SendMessage <| "Sorry, couldn't get that notebook (1)") )

                Nothing ->
                    ( model, sendToFrontend clientId (SendMessage <| "Sorry, couldn't get that notebook (2)") )

        GetPulledNotebook username slug ->
            case Dict.get slug model.slugDict of
                Just notebookRecord ->
                    case NotebookDict.lookup notebookRecord.author notebookRecord.id model.userToNoteBookDict of
                        Ok book ->
                            ( model
                            , sendToFrontend clientId
                                (GotNotebook
                                    { book
                                        | author = username
                                        , slug = BackendHelper.compress (username ++ "." ++ book.title)
                                        , origin = Just slug
                                    }
                                )
                            )

                        Err _ ->
                            ( model, sendToFrontend clientId (SendMessage <| "Sorry, couldn't get that notebook (1)") )

                Nothing ->
                    ( model, sendToFrontend clientId (SendMessage <| "Sorry, couldn't get the notebook record (2)") )

        SaveNotebook book ->
            let
                newNotebookDict =
                    NotebookDict.insert book.author book.id book model.userToNoteBookDict
            in
            ( { model | userToNoteBookDict = newNotebookDict }, Cmd.none )

        CreateNotebook author title ->
            let
                newModel =
                    BackendHelper.getUUID model

                newBook_ =
                    LiveBook.Book.new author title

                newBook =
                    { newBook_
                        | id = newModel.uuid
                        , author = author
                        , slug = BackendHelper.compress (author ++ ":" ++ title)
                        , createdAt = model.currentTime
                        , updatedAt = model.currentTime
                    }

                newNotebookDict =
                    NotebookDict.insert newBook.author newBook.id newBook model.userToNoteBookDict
            in
            ( { newModel | userToNoteBookDict = newNotebookDict }, sendToFrontend clientId (GotNotebook newBook) )

        DeleteNotebook book ->
            let
                newNotebookDict =
                    NotebookDict.remove book.author book.id model.userToNoteBookDict
            in
            ( { model | userToNoteBookDict = newNotebookDict }, Cmd.none )


setupUser : Model -> ClientId -> String -> String -> String -> ( BackendModel, Cmd BackendMsg )
setupUser model clientId email transitPassword username =
    let
        ( randInt, seed ) =
            Random.step (Random.int (Random.minInt // 2) (Random.maxInt - 1000)) model.randomSeed

        randomHex =
            Hex.toString randInt |> String.toUpper

        tokenData =
            Token.get seed

        user =
            { username = username
            , id = tokenData.token
            , realname = "Undefined"
            , email = email
            , created = model.currentTime
            , modified = model.currentTime
            , locked = False
            , currentNotebookId = Nothing
            }
    in
    case Authentication.insert user randomHex transitPassword model.authenticationDict of
        Err str ->
            ( { model | randomSeed = seed }, sendToFrontend clientId (SendMessage ("Error: " ++ str)) )

        Ok authDict ->
            ( { model | randomSeed = seed, authenticationDict = authDict }
            , Cmd.batch
                [ sendToFrontend clientId (SendMessage "Success! You have set up your account")
                , sendToFrontend clientId (SendUser user)
                ]
            )


idMessage model =
    "ids: " ++ (List.map .id model.documents |> String.join ", ")
