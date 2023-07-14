module Evergreen.V94.LiveBook.State exposing (..)

import Evergreen.V94.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V94.Value.Value
    , values : List Evergreen.V94.Value.Value
    , initialValue : Evergreen.V94.Value.Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    , fastTickInterval : Float
    }
