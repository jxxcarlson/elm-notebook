module Evergreen.V3.Authentication exposing (..)

import Dict
import Evergreen.V3.Credentials
import Evergreen.V3.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V3.User.User
    , credentials : Evergreen.V3.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
