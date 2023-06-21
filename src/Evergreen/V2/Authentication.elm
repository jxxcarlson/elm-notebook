module Evergreen.V2.Authentication exposing (..)

import Dict
import Evergreen.V2.Credentials
import Evergreen.V2.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V2.User.User
    , credentials : Evergreen.V2.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
