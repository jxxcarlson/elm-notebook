module Evergreen.V84.Authentication exposing (..)

import Dict
import Evergreen.V84.Credentials
import Evergreen.V84.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V84.User.User
    , credentials : Evergreen.V84.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
