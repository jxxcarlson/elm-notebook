module LiveBook.State exposing (..)

--( IMValue
--, parse
--, unwrapFloat
--, unwrapListFloat
--)
--

import Parser exposing ((|.), (|=), Parser)


type IMValue
    = IMFloat Float
    | IMList (List IMValue)
    | IMPoint Point


unwrapFloat : IMValue -> Maybe Float
unwrapFloat value =
    case value of
        IMFloat float ->
            Just float

        _ ->
            Nothing


unwrapListFloat : IMValue -> Maybe (List Float)
unwrapListFloat value =
    case value of
        IMList list ->
            List.map unwrapFloat list |> List.filterMap identity |> Just

        _ ->
            Nothing


unwrapPoint : IMValue -> Maybe Point
unwrapPoint value =
    case value of
        IMPoint point ->
            Just point

        _ ->
            Nothing


parse : String -> Maybe IMValue
parse str =
    Parser.run parserIMValue str
        |> Result.toMaybe


{-|

    > parse "{x = 1, y = 2}"
    Just (IMPoint { x = 1, y = 2 })

    > parse "1.234"
    Ok (IMFloat 1.234)

    > parse "[1.2 2.1]"
    Ok (IMList [IMFloat 1.2,IMFloat 2.1])

    > parse "[[1.2 2.1] [7 8]]"
    Ok (IMList [IMList [IMFloat 1.2,IMFloat 2.1],IMList [IMFloat 7,IMFloat 8]])

-}
parserIMValue : Parser IMValue
parserIMValue =
    Parser.oneOf
        [ Parser.float |> Parser.map IMFloat
        , listParser
        , pointParser |> Parser.map IMPoint
        ]


listParser : Parser IMValue
listParser =
    Parser.symbol "["
        |> Parser.andThen (\_ -> Parser.lazy (\_ -> manySeparatedBy "," parserIMValue) |> Parser.map IMList)



--|> Parser.andThen (\value -> Parser.symbol "]" |> Parser.map (\_ -> value))


type alias State a =
    { parsers : List (Parser a), results : List a }


type alias Point =
    { x : Float, y : Float }


pointToString : Point -> String
pointToString { x, y } =
    "{ x = " ++ String.fromFloat x ++ ", y = " ++ String.fromFloat y ++ " }"


stringToPoint : String -> Maybe Point
stringToPoint str =
    Parser.run pointParser str
        |> Result.toMaybe


pointParser : Parser Point
pointParser =
    Parser.succeed Point
        |. Parser.symbol "{"
        |. Parser.spaces
        |. Parser.symbol "x ="
        |. Parser.spaces
        |= Parser.float
        |. Parser.spaces
        |. Parser.symbol ","
        |. Parser.spaces
        |. Parser.symbol "y ="
        |. Parser.spaces
        |= Parser.float
        |. Parser.spaces
        |. Parser.symbol "}"


updatePoint : Float -> Float -> Point -> Point
updatePoint dx dy { x, y } =
    { x = x + dx, y = y + dy }


{-|

    > updatePointString 0.5 -0.5 "{x = 1, y = 2}"
    Just ("{ x = 1.5, y = 1.5 }")

-}
updatePointString : Float -> Float -> String -> Maybe String
updatePointString dx dy str =
    stringToPoint str
        |> Maybe.map (updatePoint dx dy)
        |> Maybe.map pointToString



-- PARSER HELPERS


sequence : List (Parser a) -> Parser (List a)
sequence parsers =
    Parser.loop { parsers = parsers, results = [] } sequenceAux


sequenceAux : State a -> Parser (Parser.Step (State a) (List a))
sequenceAux state =
    case List.head state.parsers of
        Nothing ->
            Parser.succeed () |> Parser.map (\_ -> Parser.Done (List.reverse state.results))

        Just parser ->
            parser |> Parser.map (\a -> Parser.Loop { state | results = a :: state.results, parsers = List.drop 1 state.parsers })


{-| Apply a parser zero or more times and return a list of the results.
-}
many : Parser a -> Parser (List a)
many p =
    Parser.loop [] (manyHelp p)


manyHelp : Parser a -> List a -> Parser (Parser.Step (List a) (List a))
manyHelp p vs =
    Parser.oneOf
        [ Parser.succeed (\v -> Parser.Loop (v :: vs))
            |= p
            |. Parser.spaces
        , Parser.succeed ()
            |> Parser.map (\_ -> Parser.Done (List.reverse vs))
        ]


manySeparatedBy : String -> Parser a -> Parser (List a)
manySeparatedBy sep p =
    Parser.loop [] (manySeparateByHelp sep p)


manySeparateByHelp : String -> Parser a -> List a -> Parser (Parser.Step (List a) (List a))
manySeparateByHelp sep p vs =
    Parser.oneOf
        [ Parser.succeed (\v -> Parser.Loop (v :: vs))
            |= p
            |. Parser.oneOf [ Parser.spaces |> Parser.andThen (\_ -> Parser.symbol "]"), Parser.symbol sep ]
            |. Parser.spaces
        , Parser.succeed ()
            |> Parser.map (\_ -> Parser.Done (List.reverse vs))
        ]
