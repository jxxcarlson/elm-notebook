module Authentication exposing
    ( AuthenticationDict
    , UserData
    , encryptForTransit
    , insert
    , toggleLockOnUser
    , updateUser
    , users
    , verify
    )

import Credentials exposing (Credentials)
import Crypto.HMAC exposing (sha256)
import Dict exposing (Dict)
import Env
import User exposing (User)


type alias Username =
    String


type alias UserData =
    { user : User, credentials : Credentials }


type alias AuthenticationDict =
    Dict Username UserData


users : AuthenticationDict -> List User
users authDict =
    authDict |> Dict.values |> List.map .user


toggleLockOnUser : String -> AuthenticationDict -> AuthenticationDict
toggleLockOnUser username dict =
    case Dict.get username dict of
        Nothing ->
            dict

        Just { user } ->
            toggleLockOnUser_ user dict


toggleLockOnUser_ : User -> AuthenticationDict -> AuthenticationDict
toggleLockOnUser_ user authDict =
    updateUser { user | locked = not user.locked } authDict


updateUser : User -> AuthenticationDict -> AuthenticationDict
updateUser user authDict =
    case Dict.get user.username authDict of
        Nothing ->
            authDict

        Just userData ->
            let
                newUserData =
                    { userData | user = user }
            in
            Dict.insert user.username newUserData authDict


insert : User -> String -> String -> AuthenticationDict -> Result String AuthenticationDict
insert user salt transitPassword authDict =
    case Credentials.hashPw salt transitPassword of
        Err _ ->
            Err "Please press 'Submit' again.  Sometimes it takes three tries."

        Ok credentials ->
            Ok (Dict.insert user.username { user = user, credentials = credentials } authDict)


encryptForTransit : String -> String
encryptForTransit str =
    Crypto.HMAC.digest sha256 Env.transitKey str


verify : String -> String -> AuthenticationDict -> Bool
verify username transitPassword authDict =
    case Dict.get username authDict of
        Nothing ->
            False

        Just data ->
            case Credentials.check transitPassword data.credentials of
                Ok () ->
                    True

                Err _ ->
                    False
