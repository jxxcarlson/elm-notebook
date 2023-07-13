module Evergreen.V83.LiveBook.State exposing (..)

import Evergreen.V83.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V83.Value.Value
    , values : List Evergreen.V83.Value.Value
    , initialValue : Evergreen.V83.Value.Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    }
