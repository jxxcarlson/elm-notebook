module Evergreen.V81.LiveBook.DataSet exposing (..)

import Time


type alias DataSetMetaData =
    { author : String
    , name : String
    , identifier : String
    , public : Bool
    , createdAt : Time.Posix
    , modifiedAt : Time.Posix
    , description : String
    , comments : String
    }


type alias DataSet =
    { author : String
    , name : String
    , identifier : String
    , public : Bool
    , createdAt : Time.Posix
    , modifiedAt : Time.Posix
    , description : String
    , comments : String
    , data : String
    }
