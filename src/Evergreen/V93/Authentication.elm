module Evergreen.V93.Authentication exposing (..)

import Dict
import Evergreen.V93.Credentials
import Evergreen.V93.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V93.User.User
    , credentials : Evergreen.V93.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
