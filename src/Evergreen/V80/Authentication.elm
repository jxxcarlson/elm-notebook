module Evergreen.V80.Authentication exposing (..)

import Dict
import Evergreen.V80.Credentials
import Evergreen.V80.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V80.User.User
    , credentials : Evergreen.V80.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
