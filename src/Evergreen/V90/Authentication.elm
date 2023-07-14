module Evergreen.V90.Authentication exposing (..)

import Dict
import Evergreen.V90.Credentials
import Evergreen.V90.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V90.User.User
    , credentials : Evergreen.V90.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
