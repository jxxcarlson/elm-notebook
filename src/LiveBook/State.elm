module LiveBook.State exposing
    ( MState
    , NextStateRecord
    , initialState
    , update
    , updateInModel
    , updateWorld
    , updateWorldInModel
    )

import Eval
import Eval.Types
import Value exposing (Value(..))


type alias MState =
    { currentValue : Value
    , values : List Value
    , initialValue : Value
    , probabilities : List ( String, Float )
    , ticks : Int
    , expression : String
    , bindings : List String
    }


type alias TinyModel a =
    { a | state : MState }


type alias NextStateRecord =
    { expression : String, bindings : List String }


initialState : MState
initialState =
    { currentValue = Float 10
    , values = [ Float 10 ]
    , initialValue = Float 10
    , probabilities = []
    , ticks = 0
    , expression = "if state <= 0 then 0 else state + ds p0"
    , bindings = [ "ds p = if p < 0.5 then -1 else 1" ]
    }


{-|

    > updateProbabilities [0.2, 0.8] initialState
    { nextStateRecord = { bindings = [], expression = "" }, probabilities = Dict.fromList [("p0",0.2),("p1",0.8)], ticks = 0, value = Float 0 }

-}
updateWorld : Int -> List Float -> MState -> MState
updateWorld ticks ps state =
    { state | ticks = ticks, probabilities = List.indexedMap (\i p -> ( "p" ++ String.fromInt i, p )) ps }


{-|

    This is the update function for a "mini Elm app" whose model is
    the value of "state" in model.valueDict.

-}
updateInModel : TinyModel a -> TinyModel a
updateInModel model =
    { model | state = update model.state }


updateWorldInModel : Int -> List Float -> TinyModel a -> TinyModel a
updateWorldInModel ticks ps model =
    { model | state = updateWorld ticks ps model.state }


update : MState -> MState
update state =
    let
        nexState : Result Eval.Types.Error Value
        nexState =
            evaluate state
    in
    case nexState of
        Ok value ->
            { state | currentValue = value, values = value :: state.values }

        _ ->
            state


evaluate : MState -> Result Eval.Types.Error Value
evaluate state =
    let
        stringToEvaluate_ =
            if state.bindings == [] then
                state.expression

            else
                "let\n"
                    ++ String.join "\n" state.bindings
                    ++ "\nin\n"
                    ++ state.expression

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
            Value.toString state.currentValue
    in
    word
        |> String.replace "state" val
        |> substituteProbabilities state.probabilities



--|> List.foldl folderP


{-|

    > substituteProbabilities [("p0", 0.2), ("p1", 0.8)] "abc p0, def, p1"
    "abc 0.2, def, 0.8"

-}
substituteProbabilities : List ( String, Float ) -> String -> String
substituteProbabilities probabilities word =
    List.foldl substituteProbability word probabilities


substituteProbability : ( String, Float ) -> String -> String
substituteProbability ( word, probability ) str =
    String.replace word (String.fromFloat probability) str



--|> List.foldl folderP
-- foldl : (a -> b -> b) -> b -> List a -> b
-- a : (String, Float )
-- b : String
