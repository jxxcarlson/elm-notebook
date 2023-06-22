module Backend exposing (..)

import Authentication
import Backend.Authentication
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
import UUID


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

      -- USER
      , authenticationDict = Dict.empty
      , userToNoteBookDict = Dict.empty

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
            let
                _ =
                    Debug.log "RunTask" True
            in
            ( addScratchPadToUser "jxxcarlson" model, Cmd.none )

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
                        ( model
                        , Cmd.batch
                            [ sendToFrontend clientId (SendUser userData.user)
                            , sendToFrontend clientId (GotNotebooks (NotebookDict.all username model.userToNoteBookDict))
                            ]
                        )

                    else
                        ( model, sendToFrontend clientId (SendMessage <| "Sorry, password and username don't match (1)") )

                Nothing ->
                    ( model, sendToFrontend clientId (SendMessage <| "Sorry, password and username don't match (2)") )

        -- NOTEBOOKS
        CreateNotebook author title ->
            let
                newModel =
                    getUUID model

                newBook_ =
                    LiveBook.Book.new title author

                newBook =
                    { newBook_ | id = model.uuid, slug = compress (author ++ ":" ++ title), createdAt = model.currentTime, updatedAt = model.currentTime }

                newNotebookDict =
                    NotebookDict.insert author newModel.uuid newBook model.userToNoteBookDict
            in
            ( { newModel | userToNoteBookDict = newNotebookDict }, sendToFrontend clientId (GotNotebook newBook) )


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



-- HELPERS


getUUID : Model -> Model
getUUID model =
    let
        ( uuid, seed ) =
            model.randomSeed |> Random.step UUID.generator
    in
    { model | uuid = UUID.toString uuid, randomSeed = seed }


compress : String -> String
compress str =
    str |> String.toLower |> String.replace " " ""


addScratchPadToUser : String -> Model -> Model
addScratchPadToUser username model =
    let
        newModel =
            getUUID model

        rawScratchpad =
            LiveBook.Book.scratchPad

        scratchPad =
            { rawScratchpad
                | id = newModel.uuid |> Debug.log "@@@scratchpad uuid"
                , author = username
                , title = username ++ ".Scratchpad"
                , slug = compress (username ++ ":scratchpad")
                , createdAt = model.currentTime
                , updatedAt = model.currentTime
            }

        oldUserToNoteBookDict =
            model.userToNoteBookDict

        newUserToNoteBookDict =
            NotebookDict.insert username newModel.uuid scratchPad oldUserToNoteBookDict |> Debug.log "@@@DICT"
    in
    { newModel | userToNoteBookDict = newUserToNoteBookDict }
