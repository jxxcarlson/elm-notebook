module Evergreen.V50.Authentication exposing (..)

import Dict
import Evergreen.V50.Credentials
import Evergreen.V50.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V50.User.User
    , credentials : Evergreen.V50.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
