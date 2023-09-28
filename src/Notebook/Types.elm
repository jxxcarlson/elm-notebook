module Notebook.Types exposing (EvalState, ReplData)

import Dict exposing (Dict)


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
