module Evergreen.V102.Authentication exposing (..)

import Dict
import Evergreen.V102.Credentials
import Evergreen.V102.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V102.User.User
    , credentials : Evergreen.V102.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
