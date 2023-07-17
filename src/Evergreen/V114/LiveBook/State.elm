module Evergreen.V114.LiveBook.State exposing (..)

import Evergreen.V114.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V114.Value.Value
    , values : List Evergreen.V114.Value.Value
    , initialValue : Evergreen.V114.Value.Value
    , keep : Int
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    , fastTickInterval : Float
    , stopExpressionString : String
    }
