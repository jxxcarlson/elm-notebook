module Evergreen.V95.LiveBook.State exposing (..)

import Evergreen.V95.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V95.Value.Value
    , values : List Evergreen.V95.Value.Value
    , initialValue : Evergreen.V95.Value.Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    , fastTickInterval : Float
    , stopValues : List Evergreen.V95.Value.Value
    }
