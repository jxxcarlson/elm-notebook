module Evergreen.V90.LiveBook.State exposing (..)

import Evergreen.V90.Value


type alias NextStateRecord =
    { expression : String
    , bindings : List String
    }


type alias MState =
    { currentValue : Evergreen.V90.Value.Value
    , values : List Evergreen.V90.Value.Value
    , initialValue : Evergreen.V90.Value.Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    }
