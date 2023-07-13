module Evergreen.V85.LiveBook.State exposing (..)

import Evergreen.V85.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V85.Value.Value
    , values : List Evergreen.V85.Value.Value
    , initialValue : Evergreen.V85.Value.Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    }
