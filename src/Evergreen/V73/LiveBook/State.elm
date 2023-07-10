module Evergreen.V73.LiveBook.State exposing (..)


type alias Point =
    { x : Float
    , y : Float
    }


type IMValue
    = IMFloat Float
    | IMList (List IMValue)
    | IMPoint Point
