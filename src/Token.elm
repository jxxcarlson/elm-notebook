module Token exposing (get)

import Random
import Random.Char
import Random.Int
import Random.String


get : Random.Seed -> { token : String, seed : Random.Seed }
get seed_ =
    let
        { words, seed } =
            randomWords seed_ 2 3

        ( digits, newSeed ) =
            Random.step (Random.Int.intGreaterThan 1000000) seed

        digitString =
            String.fromInt digits

        a =
            String.left 3 digitString

        b =
            String.left 3 (String.dropLeft 3 digitString)

        token =
            List.map2 (\alpha num -> String.left 2 alpha ++ num) words [ a, b ] |> String.join "-"
    in
    { token = token, seed = newSeed }


get_ : Random.Seed -> Int -> Int -> { token : String, seed : Random.Seed }
get_ seed n wordLength =
    randomWords seed n wordLength |> (\result -> { token = String.join "-" result.words, seed = result.seed })


randomWords : Random.Seed -> Int -> Int -> { words : List String, seed : Random.Seed }
randomWords seed n wordLength =
    loop
        { words = []
        , seed = seed
        , wordLength = wordLength
        , wordsToMake = n
        }
        nextState


type alias State =
    { words : List String
    , seed : Random.Seed
    , wordLength : Int
    , wordsToMake : Int
    }


nextState : State -> Step State { words : List String, seed : Random.Seed }
nextState state =
    if state.wordsToMake == 0 then
        Done { words = state.words, seed = state.seed }

    else
        let
            ( newWord, newSeed ) =
                Random.step (Random.String.string state.wordLength Random.Char.lowerCaseLatin) state.seed
        in
        Loop { state | wordsToMake = state.wordsToMake - 1, words = newWord :: state.words, seed = newSeed }


type Step state a
    = Loop state
    | Done a


loop : state -> (state -> Step state a) -> a
loop s nextState_ =
    case nextState_ s of
        Loop s_ ->
            loop s_ nextState_

        Done b ->
            b
