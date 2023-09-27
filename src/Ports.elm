port module Ports exposing
    ( receiveFromJS
    , sendDataToJS
    )

import Json.Decode exposing (Value)


port sendDataToJS : String -> Cmd msg


port receiveFromJS : (Value -> msg) -> Sub msg
