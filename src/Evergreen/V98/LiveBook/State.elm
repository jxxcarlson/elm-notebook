module Evergreen.V98.LiveBook.State exposing (..)

import Evergreen.V98.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V98.Value.Value
    , values : List Evergreen.V98.Value.Value
    , initialValue : Evergreen.V98.Value.Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    , fastTickInterval : Float
    , stopExpressionString : String
    }
