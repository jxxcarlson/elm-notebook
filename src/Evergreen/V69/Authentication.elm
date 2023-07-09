module Evergreen.V69.Authentication exposing (..)

import Dict
import Evergreen.V69.Credentials
import Evergreen.V69.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V69.User.User
    , credentials : Evergreen.V69.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
