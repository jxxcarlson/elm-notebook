module Evergreen.V61.Authentication exposing (..)

import Dict
import Evergreen.V61.Credentials
import Evergreen.V61.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V61.User.User
    , credentials : Evergreen.V61.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
