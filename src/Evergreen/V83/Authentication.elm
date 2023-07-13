module Evergreen.V83.Authentication exposing (..)

import Dict
import Evergreen.V83.Credentials
import Evergreen.V83.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V83.User.User
    , credentials : Evergreen.V83.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
