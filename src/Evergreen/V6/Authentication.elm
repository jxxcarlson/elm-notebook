module Evergreen.V6.Authentication exposing (..)

import Dict
import Evergreen.V6.Credentials
import Evergreen.V6.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V6.User.User
    , credentials : Evergreen.V6.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
