module Evergreen.V24.Authentication exposing (..)

import Dict
import Evergreen.V24.Credentials
import Evergreen.V24.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V24.User.User
    , credentials : Evergreen.V24.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
