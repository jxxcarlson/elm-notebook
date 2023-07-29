module Evergreen.V133.Authentication exposing (..)

import Dict
import Evergreen.V133.Credentials
import Evergreen.V133.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V133.User.User
    , credentials : Evergreen.V133.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
