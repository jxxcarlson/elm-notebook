module Evergreen.V85.Authentication exposing (..)

import Dict
import Evergreen.V85.Credentials
import Evergreen.V85.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V85.User.User
    , credentials : Evergreen.V85.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
