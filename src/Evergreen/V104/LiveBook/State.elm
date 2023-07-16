module Evergreen.V104.LiveBook.State exposing (..)

import Evergreen.V104.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V104.Value.Value
    , values : List Evergreen.V104.Value.Value
    , initialValue : Evergreen.V104.Value.Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    , fastTickInterval : Float
    , stopExpressionString : String
    }
