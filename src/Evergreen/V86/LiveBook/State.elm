module Evergreen.V86.LiveBook.State exposing (..)

import Evergreen.V86.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V86.Value.Value
    , values : List Evergreen.V86.Value.Value
    , initialValue : Evergreen.V86.Value.Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    }
