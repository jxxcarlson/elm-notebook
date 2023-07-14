module Evergreen.V86.Authentication exposing (..)

import Dict
import Evergreen.V86.Credentials
import Evergreen.V86.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V86.User.User
    , credentials : Evergreen.V86.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
