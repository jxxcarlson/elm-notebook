module Evergreen.V110.LiveBook.State exposing (..)

import Evergreen.V110.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V110.Value.Value
    , values : List Evergreen.V110.Value.Value
    , initialValue : Evergreen.V110.Value.Value
    , keep : Int
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    , fastTickInterval : Float
    , stopExpressionString : String
    }
