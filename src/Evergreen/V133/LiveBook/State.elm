module Evergreen.V133.LiveBook.State exposing (..)

import Evergreen.V133.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V133.Value.Value
    , values : List Evergreen.V133.Value.Value
    , initialValue : Evergreen.V133.Value.Value
    , valuesToKeep : Int
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    , fastTickInterval : Float
    , stopExpressionString : String
    }
