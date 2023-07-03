module Evergreen.V20.Authentication exposing (..)

import Dict
import Evergreen.V20.Credentials
import Evergreen.V20.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V20.User.User
    , credentials : Evergreen.V20.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
