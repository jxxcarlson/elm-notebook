module Evergreen.V37.Authentication exposing (..)

import Dict
import Evergreen.V37.Credentials
import Evergreen.V37.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V37.User.User
    , credentials : Evergreen.V37.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
