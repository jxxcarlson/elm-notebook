module Evergreen.V76.Authentication exposing (..)

import Dict
import Evergreen.V76.Credentials
import Evergreen.V76.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V76.User.User
    , credentials : Evergreen.V76.Credentials.Credentials
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
