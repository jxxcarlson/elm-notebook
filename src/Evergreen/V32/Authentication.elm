module Evergreen.V32.Authentication exposing (..)

import Dict
import Evergreen.V32.Credentials
import Evergreen.V32.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V32.User.User
    , credentials : Evergreen.V32.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
