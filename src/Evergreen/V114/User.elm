module Evergreen.V114.User exposing (..)

import Time


type alias User =
    { username : String
    , id : String
    , realname : String
    , email : String
    , created : Time.Posix
    , modified : Time.Posix
    , locked : Bool
    , currentNotebookId : Maybe String
    }
