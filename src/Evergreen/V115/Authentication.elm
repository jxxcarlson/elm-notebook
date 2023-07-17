module Evergreen.V115.Authentication exposing (..)

import Dict
import Evergreen.V115.Credentials
import Evergreen.V115.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V115.User.User
    , credentials : Evergreen.V115.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
