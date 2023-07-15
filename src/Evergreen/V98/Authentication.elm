module Evergreen.V98.Authentication exposing (..)

import Dict
import Evergreen.V98.Credentials
import Evergreen.V98.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V98.User.User
    , credentials : Evergreen.V98.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
