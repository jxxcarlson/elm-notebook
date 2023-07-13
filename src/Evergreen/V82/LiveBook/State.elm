module Evergreen.V82.LiveBook.State exposing (..)

import Evergreen.V82.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { value : Evergreen.V82.Value.Value
    , values : List Evergreen.V82.Value.Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    }
