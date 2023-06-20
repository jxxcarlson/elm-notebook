module Backend.Authentication exposing (signIn, signOut, signUpUser)

import Authentication
import Dict
import Hex
import Lamdera exposing (ClientId, SessionId)
import Random
import Set
import Token
import Types exposing (BackendModel, BackendMsg, MessageStatus(..), ToFrontend(..))


signIn model sessionId clientId username encryptedPassword =
    case Dict.get username model.authenticationDict of
        Just userData ->
            if Authentication.verify username encryptedPassword model.authenticationDict then
                ( model
                , Cmd.batch
                    [ Lamdera.sendToFrontend clientId (UserSignedIn userData.user clientId)
                    ]
                )

            else
                ( model, Lamdera.sendToFrontend clientId (MessageReceived <| { txt = "Sorry, password and username don't match", status = MSRed }) )

        Nothing ->
            ( model, Lamdera.sendToFrontend clientId (MessageReceived <| { txt = "Sorry, password and username don't match", status = MSRed }) )


{-|

        This function differs from  removeSessionClient only in (a) it does not use the sessionId,
        (b) it treats the connectionDict more gingerely.

-}
signOut : BackendModel -> Types.Username -> ClientId -> ( BackendModel, Cmd BackendMsg )
signOut model username clientId =
    ( model, Cmd.none )


signUpUser : BackendModel -> SessionId -> ClientId -> String -> String -> String -> ( BackendModel, Cmd BackendMsg )
signUpUser model sessionId clientId username transitPassword email =
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
            , email = email
            , realname = "blank"
            , created = model.currentTime
            , modified = model.currentTime
            , locked = False
            }
    in
    case Authentication.insert user randomHex transitPassword model.authenticationDict of
        Err str ->
            ( { model | randomSeed = tokenData.seed }, Lamdera.sendToFrontend clientId (MessageReceived { txt = "Error: " ++ str, status = MSRed }) )

        Ok authDict ->
            ( { model
                | randomSeed = tokenData.seed
                , authenticationDict = authDict
              }
            , Cmd.batch
                [ Lamdera.sendToFrontend clientId (UserSignedIn user clientId)
                , Lamdera.sendToFrontend clientId (MessageReceived { txt = "Success! Your account is set up.", status = MSGreen })
                ]
            )


createUser : String -> String -> String -> String -> BackendModel -> BackendModel
createUser username password realname email model =
    case Dict.get username model.authenticationDict of
        Nothing ->
            createUser_ username password realname email model

        Just _ ->
            model


createUser_ : String -> String -> String -> String -> BackendModel -> BackendModel
createUser_ username password realname email model =
    let
        transitPassword =
            Authentication.encryptForTransit password

        ( randInt, seed ) =
            Random.step (Random.int (Random.minInt // 2) (Random.maxInt - 1000)) model.randomSeed

        randomHex =
            Hex.toString randInt |> String.toUpper

        tokenData =
            Token.get seed

        user =
            { username = username
            , id = tokenData.token
            , realname = realname
            , email = email
            , created = model.currentTime
            , modified = model.currentTime
            , locked = False
            }
    in
    case Authentication.insert user randomHex transitPassword model.authenticationDict of
        Err _ ->
            { model | randomSeed = tokenData.seed }

        Ok authDict ->
            { model
                | randomSeed = tokenData.seed
                , authenticationDict = authDict
            }



--
