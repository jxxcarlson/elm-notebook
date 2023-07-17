module Evergreen.V110.Authentication exposing (..)

import Dict
import Evergreen.V110.Credentials
import Evergreen.V110.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V110.User.User
    , credentials : Evergreen.V110.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
