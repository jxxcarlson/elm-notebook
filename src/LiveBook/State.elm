module LiveBook.State exposing
    ( MState
    , NextStateRecord
    , initialState
    , update
    , updateInModel
    , updateProbabilities
    , updateProbabilitiesInModel
    )

import Dict exposing (Dict)
import Eval
import Eval.Types
import Value exposing (Value(..))


type alias MState =
    { value : Value
    , probabilities : Dict String Float
    , ticks : Int
    , nextStateRecord : NextStateRecord
    }


type alias TinyModel a =
    { a | state : MState }


type alias NextStateRecord =
    { expression : String, bindings : List String }


initialState : MState
initialState =
    { value = Float 0
    , probabilities = Dict.empty
    , ticks = 0
    , nextStateRecord = { expression = "", bindings = [] }
    }


{-|

    > updateProbabilities [0.2, 0.8] initialState
    { nextStateRecord = { bindings = [], expression = "" }, probabilities = Dict.fromList [("p0",0.2),("p1",0.8)], ticks = 0, value = Float 0 }

-}
updateProbabilities : List Float -> MState -> MState
updateProbabilities ps state =
    { state | probabilities = Dict.fromList (List.indexedMap (\i p -> ( "p" ++ String.fromInt i, p )) ps) }


{-|

    This is the update function for a "mini Elm app" whose model is
    the value of "state" in model.valueDict.

-}
updateInModel : TinyModel a -> TinyModel a
updateInModel model =
    { model | state = update model.state }


updateProbabilitiesInModel : List Float -> TinyModel a -> TinyModel a
updateProbabilitiesInModel ps model =
    { model | state = updateProbabilities ps model.state }


update : MState -> MState
update state =
    let
        nexState : Result Eval.Types.Error Value
        nexState =
            evaluate state
    in
    case nexState of
        Ok value ->
            { state | value = value }

        _ ->
            state


evaluate : MState -> Result Eval.Types.Error Value
evaluate state =
    let
        stringToEvaluate_ =
            if state.nextStateRecord.bindings == [] then
                state.nextStateRecord.expression

            else
                "let\n"
                    ++ String.join "\n" state.nextStateRecord.bindings
                    ++ "\nin\n"
                    ++ state.nextStateRecord.expression

        stringToEvaluate =
            stringToEvaluate_
                |> String.words
                |> List.map (makeSubstitutions state)
                |> String.join " "
    in
    Eval.eval stringToEvaluate


makeSubstitutions : MState -> String -> String
makeSubstitutions state word =
    let
        val =
            Value.toString state.value
    in
    String.replace "state" val word
