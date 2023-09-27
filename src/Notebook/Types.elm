module Notebook.Types exposing (Msg(..), ReplData)

import Http
import Json.Decode exposing (Value)
import Keyboard


type alias ReplData =
    { name : Maybe String
    , value : String
    , tipe : String
    }


type Msg
    = NoOp
    | InputText String
    | RequestEval
    | GotReply (Result Http.Error String)
      -- | ReceivedFromJS Value
    | KeyboardMsg Keyboard.Msg
