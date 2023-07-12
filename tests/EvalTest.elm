module EvalTest exposing (..)

import Dict exposing (Dict)
import Eval
import Eval.Types
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import List.Extra
import LiveBook.Eval
import LiveBook.Types exposing (Cell, CellState(..), CellValue(..))
import Test exposing (..)
import Value exposing (Value)


{-|

    This function is used exclusively for testing.

-}
evaluateWithCumulativeBindingsToResult : Dict String String -> List Cell -> Cell -> Result Eval.Types.Error Value
evaluateWithCumulativeBindingsToResult kvDict cells cell =
    let
        ( stringToEvaluate, _ ) =
            LiveBook.Eval.evaluateWithCumulativeBindingsCore Dict.empty kvDict cells cell
    in
    Eval.eval stringToEvaluate


testCell : Int -> List String -> Cell
testCell index strings =
    { index = index
    , text = strings
    , bindings = []
    , expression = ""
    , value = CVNone
    , cellState = CSView
    , locked = False
    }


type alias TestDatum =
    List (List String)


makeCells : List (List String) -> List Cell
makeCells testDatum =
    List.indexedMap (\index strings -> testCell index strings) testDatum


makeTest : List (List String) -> Expectation
makeTest testDatum =
    let
        cells =
            makeCells testDatum
    in
    case List.Extra.unconsLast cells of
        Nothing ->
            Expect.fail "No cells"

        Just ( cells_, cell_ ) ->
            Expect.ok <| evaluateWithCumulativeBindingsToResult Dict.empty cell_ cells_


suite : Test
suite =
    describe "The LiveBook.Eval module"
        -- Nest as many descriptions as you like.
        [ test "succeeds with '> 1 + 1 == 1'" <|
            \_ ->
                makeTest [ [ "> 1 + 1 == 2" ] ]
        , test "fails with a" <|
            \_ ->
                makeTest [ [ "a" ] ]
        , test "fails with A" <|
            \_ ->
                makeTest [ [ "A" ] ]
        , test "fails with ???" <|
            \_ ->
                makeTest
                    [ [ "> last list ="
                      , "let"
                      , "  n = List.length list"
                      , "in"
                      , "list |> List.drop (n - 1) |> List.head"
                      ]
                    ]
        , test "succeeds with # *A sequence of definitions*; > a = 2; b = 5?" <|
            \_ ->
                makeTest
                    [ [ "# *A sequence of definitions*"
                      , "> a = 2"
                      , "> b = 5"
                      ]
                    ]
        , test "succeeds text of previous test plus '> a * b'" <|
            \_ ->
                makeTest
                    [ [ "# *A sequence of definitions*"
                      , "> a = 2"
                      , "> b = 5"
                      ]
                    , [ "# *An expression may refer to prior definitions:*"
                      , "> a * b"
                      ]
                    ]
        , test "succeeds with '> x = 3.2;> y = 2.9; > x + 7" <|
            \_ ->
                makeTest
                    [ [ "# *A sequence of definitions followed by an expression:*"
                      , "> x = 3.2"
                      , "> y = 2.9"
                      , "> x + y"
                      ]
                    ]
        , test "succeeds with '> List.map (\n -> n * n) [1, 2, 3, 4, 5, 6]'" <|
            \_ ->
                makeTest
                    [ [ "# *A higher order function and a list of squares:*"
                      , "> List.map (\n -> n * n) [1, 2, 3, 4, 5, 6]"
                      ]
                    ]
        , test "succeeds with a pipeline of computations" <|
            \_ ->
                makeTest
                    [ [ "# *A pipeline of computations:*"
                      , "> \"a, b, c\" |> String.split \",\" |> List.map String.trim |> List.reverse |> String.join \"\""
                      ]
                    ]
        , test "succeeds with definition of factorial function" <|
            \_ ->
                makeTest
                    [ [ "# *Recursion:*"
                      , "> factorial n = if n == 0 then 1 else n * factorial (n - 1)"
                      ]
                    ]
        , test "succeeds with definition and application of the factorial function" <|
            \_ ->
                makeTest
                    [ [ "# *Recursion:*"
                      , "> factorial n = if n == 0 then 1 else n * factorial (n - 1)"
                      ]
                    , [ "> factorial 5" ]
                    ]
        , test "succeeds with definition and application of the factorial function + List.map ..." <|
            \_ ->
                makeTest
                    [ [ "# *Recursion:*"
                      , "> factorial n = if n == 0 then 1 else n * factorial (n - 1)"
                      ]
                    , [ "> factorial 5" ]
                    , [ "> List.map factorial [ 1, 2, 3, 4, 5, 6, 7, 8 ]" ]
                    ]
        , test "succeeds with computation of number of sunspot observations." <|
            \_ ->
                makeTest
                    [ [ "# Something not working here:"
                      , "> n = sunspots |> String.lines |> List.length"
                      ]
                    ]
        ]
