module Evergreen.V82.Authentication exposing (..)

import Dict
import Evergreen.V82.Credentials
import Evergreen.V82.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V82.User.User
    , credentials : Evergreen.V82.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
