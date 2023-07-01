module Evergreen.V1.Authentication exposing (..)

import Dict
import Evergreen.V1.Credentials
import Evergreen.V1.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V1.User.User
    , credentials : Evergreen.V1.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
