module Example exposing (..)

import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import List.Extra
import LiveBook.Eval
import LiveBook.Types exposing (Cell, CellState(..), CellValue(..))
import Test exposing (..)


testCell : Int -> List String -> Cell
testCell index strings =
    { index = index, text = strings, value = CVNone, cellState = CSView, locked = False }


type alias TestDatum =
    List (List String)


datum1 =
    [ [ "> 1 + 1 == 2" ] ]


makeCells : List (List String) -> List Cell
makeCells testDatum =
    List.indexedMap (\index strings -> testCell index strings) testDatum


makeTest : List (List String) -> Expectation


magkeTest testDatum =
    let
        cells =
            makeCells testDatum
    in
    case List.Extra.unconsLast cells of
        Nothing ->
            Expect.fail "No cells"

        Just ( cells_, cell_ ) ->
            Expect.ok <| LiveBook.Eval.evaluateWithCumulativeBindingsToResult Dict.empty cell_ cells_


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
        ]
