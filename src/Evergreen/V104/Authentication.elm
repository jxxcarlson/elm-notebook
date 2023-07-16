module Evergreen.V104.Authentication exposing (..)

import Dict
import Evergreen.V104.Credentials
import Evergreen.V104.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V104.User.User
    , credentials : Evergreen.V104.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
