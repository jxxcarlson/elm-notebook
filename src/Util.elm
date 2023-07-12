module Util exposing
    ( firstPart
    , getChunks
    , insertInList
    , roundTo
    , secondPart
    )

import List.Extra


roundTo : Int -> Float -> Float
roundTo n x =
    let
        factor =
            10.0 ^ toFloat n
    in
    (x * factor) |> round |> (\x_ -> toFloat x_ / factor)


{-| Copilot almost wrote this
-}
getChunks : List String -> List (List String)
getChunks lines =
    (getChunks_ { input = lines, output = [] }).output |> List.filter (\chnk -> chnk /= [])


{-| Copilot wrote this with one correction by a human

    > xxx = ["a","b","","c","d","e","","f"]
    > getChunks xxx
    REST: ["c","d","e","","f"]
    REST: ["f"]
    REST: []
    [["a","b"],["c","d","e"],["f"]]
        : List (List String)

    > yyy = ["a","b","","", "c","d","e","","f"]
    > getChunks yyy
    REST: ["","c","d","e","","f"]
    REST: ["c","d","e","","f"]
    REST: ["f"]
    REST: []
    [["a","b"],["c","d","e"],["f"]]

-}
getChunks_ : { input : List String, output : List (List String) } -> { input : List String, output : List (List String) }
getChunks_ { input, output } =
    if input == [] then
        { input = [], output = output }

    else
        let
            chunk_ =
                chunk input

            rest =
                List.drop (List.length chunk_ + 1) input
        in
        getChunks_ { input = rest, output = output ++ [ chunk_ ] }


chunk : List String -> List String
chunk lines_ =
    List.Extra.takeWhile (\line_ -> String.trim line_ /= "") lines_


insertInList : a -> List a -> List a
insertInList a list =
    if List.Extra.notMember a list then
        a :: list

    else
        list


{-|

        This function is used to get the part of a string
    before the dot, assuming the string has the form x.y (single dot)

-}
firstPart : String -> Maybe String
firstPart str =
    let
        parts =
            String.split "." str
    in
    parts
        |> List.head


{-|

        This function is used to get the part of a string
    after the dot, assuming the string has the form x.y (single dot)

-}
secondPart : String -> Maybe String
secondPart str =
    let
        parts =
            String.split "." str
    in
    parts
        |> List.drop 1
        |> List.head
