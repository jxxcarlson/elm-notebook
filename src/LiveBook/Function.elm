module LiveBook.Function exposing
    ( correlation
    , roundTo
    , wrangleToListFloatPair
    )

import Dict exposing (Dict)
import List.Extra
import Maybe.Extra
import Stat
import String exposing (split)


roundTo : Int -> Float -> Float
roundTo n x =
    let
        factor =
            10.0 ^ toFloat n
    in
    ((x * factor) |> round |> toFloat) / factor


wrangleToListFloatPair : Maybe (List Int) -> String.String -> Maybe (List ( Float, Float ))
wrangleToListFloatPair colSelector str_ =
    str_
        |> toStringListList
        |> selectColumns colSelector
        |> Maybe.andThen (List.map (List.map String.toFloat >> Maybe.Extra.combine) >> Maybe.Extra.combine)
        |> Maybe.andThen twoListToPairList


hu =
    "S.Mag,0.032,170\nL.Mag,0.034,290\nNGC.6822,0.214,-130\nNGC.598,0.263,-70"


{-|

    > str
    "1.1,    1.2, 1.3\n2.1, 2.2, 2.3" : String

    > toFloatListList str
    Just [[1.1,1.2,1.3],[2.1,2.2,2.3]]
        : Maybe (List (List Float))

-}
toFloatListList : String -> Maybe (List (List Float))
toFloatListList data =
    data
        |> String.lines
        |> List.map String.trim
        |> List.filter ((/=) "")
        |> List.map (String.split "," >> List.map String.trim >> List.map String.toFloat)
        |> List.map Maybe.Extra.combine
        |> Maybe.Extra.combine


{-|

    > hu
    "S.Mag,0.032,170\nL.Mag,0.034,290\nNGC.6822,0.214,-130\nNGC.598,0.263,-70\nNGC.221,0.275,-185\nNGC.224,0.275,-220\nNGC.5457,0.45,200\nNGC.4736,0.5,290\nNGC.5194,0.5,270\nNGC.4449,0.63,200\nNGC.4214,0.8,30\n  0\nNGC.3031,0.9,-30\nNGC.3627,0.9,650\nNGC.4826,0.9,150\nNGC.5236,0.9,500\nNGC.1068,1.0,920\nNGC.5055,1.1,450\nNGC.7331,1.1,500\nNGC.4258,1.4,500\nNGC.4151,1.7,960\nNGC.4382,2.0,500\nNGC.4472,2.0,850\nNG\n  C.4486,2.0,800\nNGC.4649,2.0,1090"
        : String
    > ll = toStringListList hu
    [["S.Mag","0.032","170"],["L.Mag","0.034","290"],["NGC.6822","0.214","-130"],["NGC.598","0.263","-70"],["NGC.221","0.275","-185"],["NGC.224","0.275","-220"],["NGC.5457","0.45","200"],["NGC.4736","0.5","290"],["NGC.5194","0.5","270"],["NGC.4449","0.63","200"],["NGC.4214","0.8","30"],["0"],["NGC.3031","0.9","-30"],["NGC.3627","0.9","650"],["NGC.4826","0.9","150"],["NGC.5236","0.9","500"],["NGC.1068","1.0","920"],["NGC.5055","1.1","450"],["NGC.7331","1.1","500"],["NGC.4258","1.4","500"],["NGC.4151","1.7","960"],["NGC.4382","2.0","500"],["NGC.4472","2.0","850"],["NG"],["C.4486","2.0","800"],["NGC.4649","2.0","1090"]]

-}
toStringListList : String -> List (List String)
toStringListList data =
    data
        |> String.lines
        |> List.map String.trim
        |> List.filter ((/=) "")
        |> List.map (String.split "," >> List.map String.trim)


correlation : Int -> Int -> List (List Float) -> Maybe Float
correlation column1 column2 data =
    case selectColumns (Just [ column1, column2 ]) data of
        Just [ column1Data, column2Data ] ->
            Stat.correlation (List.map2 (\x y -> ( x, y )) column1Data column2Data)

        _ ->
            Nothing


{-|

    Nothing : Maybe (List (List String))
    > select (Just [1,2]) ["0", "1", "2"]
    Just ["1","2"] : Maybe (List String)

-}
select : Maybe (List Int) -> List a -> Maybe (List a)
select columns_ data =
    case columns_ of
        Nothing ->
            Just data

        Just columns ->
            let
                selectors : List (List a -> Maybe a)
                selectors =
                    List.map List.Extra.getAt columns
            in
            applyFunctions selectors data |> Maybe.Extra.combine


{-|

    > str
    "1.1, 1.2, 1.3\n2.1, 2.2, 2.3" : String

    > toFloatListList str |> Maybe.andThen (selectColumns (Just[1,2]))
    Just [[1.2,1.3],[2.2,2.3]]

-}
selectColumns : Maybe (List Int) -> List (List a) -> Maybe (List (List a))
selectColumns columns data =
    if columns == Just [] then
        Just data

    else
        List.map (select columns) data |> Maybe.Extra.combine


twoListToPair : List Float -> Maybe ( Float, Float )
twoListToPair list =
    case list of
        [ x, y ] ->
            Just ( x, y )

        _ ->
            Nothing


twoListToPairList : List (List Float) -> Maybe (List ( Float, Float ))
twoListToPairList list =
    List.map twoListToPair list |> Maybe.Extra.combine


toFloatList : List String -> Maybe (List Float)
toFloatList lines =
    List.map String.toFloat lines |> Maybe.Extra.combine



--getColumns : Int -> Int -> String -> Maybe (List (List Float))
--getColumns column1 column2 data =
--    data
--        |> Debug.log "@@LINES (1)"
--        |> String.lines
--        |> Debug.log "@@LINES (2)"
--        |> List.map (split ",")
--        |> Debug.log "@@LINES (3)"
--        --|> selectColumns (Just [ column1, column2 ])
--        |> selectColumns (Just [ column1 ])
--        |> Debug.log "@@LINES (4)"
--        |> Maybe.andThen listListStringToListListFloat
--        |> Debug.log "@@LINES (5)"
--


{-|

    > ll = [["1", "2"], ["3", "4"]]
    [["1","2"],["3","4"]] : List (List String)
    > listListStringToListListFloat ll
    Just [[1,2],[3,4]]

-}
listListStringToListListFloat : List (List String.String) -> Maybe (List (List Float))
listListStringToListListFloat =
    List.map (List.map String.toFloat >> Maybe.Extra.combine)
        >> Maybe.Extra.combine


applyFunctions : List (a -> b) -> a -> List b
applyFunctions fs a =
    List.foldl (\f acc -> f a :: acc) [] fs |> List.reverse
