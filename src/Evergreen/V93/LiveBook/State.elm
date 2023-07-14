module Evergreen.V93.LiveBook.State exposing (..)

import Evergreen.V93.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V93.Value.Value
    , values : List Evergreen.V93.Value.Value
    , initialValue : Evergreen.V93.Value.Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    }
