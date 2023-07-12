module LiveBook.State exposing
    ( MState
    , NextStateRecord
    , initialState
    , update
    , updateInModel
    )

import Eval
import Eval.Types
import List.Extra
import Value exposing (Value(..))


type alias MState =
    { value : Value
    , probabilityVector : List Float
    , ticks : Int
    , nextStateRecord : NextStateRecord
    }


initialState : MState
initialState =
    { value = Float 0
    , probabilityVector = [ 1 ]
    , ticks = 0
    , nextStateRecord = { expression = "", bindings = [] }
    }


getProbability : MState -> Int -> Float
getProbability state index =
    List.Extra.getAt index state.probabilityVector
        |> Maybe.withDefault 0


type alias TinyModel a =
    { a | state : MState }


type alias NextStateRecord =
    { expression : String, bindings : List String }


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


{-|

    This is the update function for a "mini Elm app" whose model is
    the value of "state" in model.valueDict.

-}
updateInModel : TinyModel a -> TinyModel a
updateInModel model =
    { model | state = update model.state }
