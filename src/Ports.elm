port module Ports exposing
    ( receiveFromJS
    , sendData
    , sendDataToJS
    )


port sendDataToJS : String -> Cmd msg


port receiveFromJS : (String -> msg) -> Sub msg


port sendData : String -> Cmd msg
