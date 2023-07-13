module StateTest exposing (..)

import Dict exposing (Dict)
import Eval
import Eval.Types
import Expect exposing (Expectation)
import List.Extra
import LiveBook.Eval
import LiveBook.State exposing (MState, NextStateRecord, update)
import LiveBook.Types exposing (Cell, CellState(..), CellValue(..))
import Test exposing (..)
import Value exposing (Value)


testState : MState -> Value -> Expectation
testState state value =
    Expect.equal (update state).currentValue value


nextStateRecord1 : NextStateRecord
nextStateRecord1 =
    { expression = "2 * state", bindings = [] }


initialState1 : MState
initialState1 =
    { value = Value.Float 1.2
    , probabilities = []
    , ticks = 0
    , nextStateRecord = nextStateRecord1
    }


initialState2 : MState
initialState2 =
    { value = Value.Tuple (Value.Float 5.1) (Value.Float 7.1)
    , probabilities = [ ( "p0", 0.2 ), ( "p1", 0.8 ) ]
    , ticks = 0
    , nextStateRecord =
        { expression = "( Tuple.first state + ds p0 , Tuple.second state + ds p1 )"
        , bindings = [ "ds p = if p < 0.5 then -1 else 1" ]
        }
    }


suite : Test
suite =
    describe "The LiveBook.State module"
        [ test "succeeds for model : Value.Float" <|
            \_ ->
                testState initialState1 (Value.Float 2.4)
        , test "succeeds for model : Tuple Value.Float Value.Float" <|
            \_ ->
                testState initialState2 (Value.Tuple (Value.Float 4.1) (Value.Float 8.1))
        ]
