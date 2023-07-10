module Evergreen.V74.Authentication exposing (..)

import Dict
import Evergreen.V74.Credentials
import Evergreen.V74.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V74.User.User
    , credentials : Evergreen.V74.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
