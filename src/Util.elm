module Util exposing (firstPart, insertInList, secondPart)

import List.Extra


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
