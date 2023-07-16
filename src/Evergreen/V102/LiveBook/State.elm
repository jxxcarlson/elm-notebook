module Evergreen.V102.LiveBook.State exposing (..)

import Evergreen.V102.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V102.Value.Value
    , values : List Evergreen.V102.Value.Value
    , initialValue : Evergreen.V102.Value.Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    , fastTickInterval : Float
    , stopExpressionString : String
    }
