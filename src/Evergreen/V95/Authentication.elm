module Evergreen.V95.Authentication exposing (..)

import Dict
import Evergreen.V95.Credentials
import Evergreen.V95.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V95.User.User
    , credentials : Evergreen.V95.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
