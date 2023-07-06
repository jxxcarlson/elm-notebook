module Evergreen.V58.Authentication exposing (..)

import Dict
import Evergreen.V58.Credentials
import Evergreen.V58.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V58.User.User
    , credentials : Evergreen.V58.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
