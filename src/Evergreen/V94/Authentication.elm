module Evergreen.V94.Authentication exposing (..)

import Dict
import Evergreen.V94.Credentials
import Evergreen.V94.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V94.User.User
    , credentials : Evergreen.V94.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
