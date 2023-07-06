module Evergreen.V63.Authentication exposing (..)

import Dict
import Evergreen.V63.Credentials
import Evergreen.V63.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V63.User.User
    , credentials : Evergreen.V63.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
