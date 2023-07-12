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
    Expect.equal (update state).value value



--type alias State =
--    { value : Value
--    , probabilityVector : List Float
--    , ticks : Int
--    , nextStateRecord : Maybe NextStateRecord
--    }


nextStateRecord1 : NextStateRecord
nextStateRecord1 =
    { expression = "2 * state", bindings = [] }


initialState1 : MState
initialState1 =
    { value = Value.Float 1.2
    , probabilities = Dict.empty
    , ticks = 0
    , nextStateRecord = nextStateRecord1
    }


suite : Test
suite =
    describe "The LiveBook.State module"
        [ test "succeeds for model value a Value.Float" <|
            \_ ->
                testState initialState1 (Value.Float 2.4)
        ]
