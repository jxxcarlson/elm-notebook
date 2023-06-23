module Evergreen.V30.Authentication exposing (..)

import Dict
import Evergreen.V30.Credentials
import Evergreen.V30.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V30.User.User
    , credentials : Evergreen.V30.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
