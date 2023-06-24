module Evergreen.V40.Authentication exposing (..)

import Dict
import Evergreen.V40.Credentials
import Evergreen.V40.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V40.User.User
    , credentials : Evergreen.V40.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
