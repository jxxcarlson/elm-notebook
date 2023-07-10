module Evergreen.V73.Authentication exposing (..)

import Dict
import Evergreen.V73.Credentials
import Evergreen.V73.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V73.User.User
    , credentials : Evergreen.V73.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
