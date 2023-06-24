module Evergreen.V42.Authentication exposing (..)

import Dict
import Evergreen.V42.Credentials
import Evergreen.V42.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V42.User.User
    , credentials : Evergreen.V42.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
