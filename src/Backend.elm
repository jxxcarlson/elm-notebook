module Backend exposing (..)

import Authentication
import Backend.Authentication
import Dict
import Env exposing (Mode(..))
import Hex
import ImageDict
import Lamdera exposing (ClientId, SessionId, sendToFrontend)
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
      , randomAtmosphericInt = Nothing
      , currentTime = Time.millisToPosix 0

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
            ( { model | authenticationDict = Authentication.toggleLockOnUser "publicdemo" model.authenticationDict }, Cmd.none )

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
                            ]
                        )

                    else
                        ( model, sendToFrontend clientId (SendMessage <| "Sorry, password and username don't match (1)") )

                Nothing ->
                    ( model, sendToFrontend clientId (SendMessage <| "Sorry, password and username don't match (2)") )


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


{-| space the records at least one minute apart, assuming equal upload times
-}
updateUploadTimeImageDict : ImageDict -> ImageDict
updateUploadTimeImageDict dict =
    dict
        |> Dict.toList
        |> List.indexedMap (\k ( id, imageRecord ) -> ( id, { imageRecord | timeUploaded = Time.millisToPosix <| Time.posixToMillis imageRecord.timeUploaded + k * 60000 } ))
        |> Dict.fromList


updateUploadTimeImageUserDict : ImageUserDict -> ImageUserDict
updateUploadTimeImageUserDict dict =
    dict
        |> Dict.toList
        |> List.map (\( username, imageDict ) -> ( username, updateUploadTimeImageDict imageDict ))
        |> Dict.fromList
