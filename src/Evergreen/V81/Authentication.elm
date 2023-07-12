module Evergreen.V81.Authentication exposing (..)

import Dict
import Evergreen.V81.Credentials
import Evergreen.V81.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V81.User.User
    , credentials : Evergreen.V81.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
