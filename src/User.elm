module User exposing (User, guest)

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


defaultUser =
    { username = "jxxcarlson"
    , id = "ekvdo-oaeaw"
    , realname = "James Carlson"
    , email = "jxxcarlson@gmail.com"
    , created = Time.millisToPosix 0
    , modified = Time.millisToPosix 0
    , locked = False
    }


guest =
    { username = "guest"
    , id = "ekvdo-tseug"
    , realname = "Guest"
    , email = "guest@nonexistent.com"
    , created = Time.millisToPosix 0
    , modified = Time.millisToPosix 0
    , locked = True
    }
