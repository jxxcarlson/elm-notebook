module Evergreen.V17.Authentication exposing (..)

import Dict
import Evergreen.V17.Credentials
import Evergreen.V17.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V17.User.User
    , credentials : Evergreen.V17.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
