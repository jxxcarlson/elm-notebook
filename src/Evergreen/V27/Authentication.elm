module Evergreen.V27.Authentication exposing (..)

import Dict
import Evergreen.V27.Credentials
import Evergreen.V27.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V27.User.User
    , credentials : Evergreen.V27.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
