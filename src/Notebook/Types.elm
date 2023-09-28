module Notebook.Types exposing (EvalState, Model, ReplData)

import Dict exposing (Dict)
import Http
import Keyboard
import Notebook.ErrorReporter as ErrorReporter


type alias Model =
    { expressionText : String
    , report : List ErrorReporter.MessageItem
    , replData : Maybe ReplData
    , evalState : EvalState
    , pressedKeys : List Keyboard.Key
    }


type alias EvalState =
    { decls : Dict String String
    , types : Dict String String
    , imports : Dict String String
    }


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
    | ReceivedFromJS String
    | KeyboardMsg Keyboard.Msg
