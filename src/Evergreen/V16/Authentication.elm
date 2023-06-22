module Evergreen.V16.Authentication exposing (..)

import Dict
import Evergreen.V16.Credentials
import Evergreen.V16.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V16.User.User
    , credentials : Evergreen.V16.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
