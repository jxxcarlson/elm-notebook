module Evergreen.V23.Authentication exposing (..)

import Dict
import Evergreen.V23.Credentials
import Evergreen.V23.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V23.User.User
    , credentials : Evergreen.V23.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
