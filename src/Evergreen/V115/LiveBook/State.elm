module Evergreen.V115.LiveBook.State exposing (..)

import Evergreen.V115.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V115.Value.Value
    , values : List Evergreen.V115.Value.Value
    , initialValue : Evergreen.V115.Value.Value
    , valuesToKeep : Int
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    , fastTickInterval : Float
    , stopExpressionString : String
    }
