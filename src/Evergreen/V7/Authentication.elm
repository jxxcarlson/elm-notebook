module Evergreen.V7.Authentication exposing (..)

import Dict
import Evergreen.V7.Credentials
import Evergreen.V7.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V7.User.User
    , credentials : Evergreen.V7.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
