module Evergreen.V64.Authentication exposing (..)

import Dict
import Evergreen.V64.Credentials
import Evergreen.V64.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V64.User.User
    , credentials : Evergreen.V64.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
