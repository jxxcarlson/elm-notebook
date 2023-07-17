module Evergreen.V114.Authentication exposing (..)

import Dict
import Evergreen.V114.Credentials
import Evergreen.V114.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V114.User.User
    , credentials : Evergreen.V114.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
