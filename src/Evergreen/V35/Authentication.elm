module Evergreen.V35.Authentication exposing (..)

import Dict
import Evergreen.V35.Credentials
import Evergreen.V35.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V35.User.User
    , credentials : Evergreen.V35.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
