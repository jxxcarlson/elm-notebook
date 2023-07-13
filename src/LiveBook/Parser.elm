module LiveBook.Parser exposing (..)

import Parser exposing ((|.), (|=), Parser)
import Value exposing (Value(..))


{-|

    > parse "1.2"
    Just (Float 1.2)

    > parse "[1.1, 2.2]"
    Just (List [Float 1.1,Float 2.2])

    > parse "[[1.1, 2.2], [7,8]]"
    Just (List [List [Float 1.1,Float 2.2],List [Float 7,Float 8]])


     INCORRECT (using manySeparatedBy2)
     > parse "[[1.1, 2.2], [7,8]]"
     Just (List [List [Float 1.1,Float 2.2]])

-}
parse : String -> Maybe Value
parse str =
    Parser.run valueParser str
        |> Result.toMaybe


valueParser : Parser Value
valueParser =
    Parser.oneOf
        [ Parser.lazy (\_ -> pairParser)
        , signedFloat
        , Parser.float |> Parser.map Float
        , listParser
        ]


parseListFloatPair : String -> Maybe (List ( Float, Float ))
parseListFloatPair str =
    Parser.run listFloatPairParser str
        |> Result.toMaybe


listFloatPairParser : Parser (List ( Float, Float ))
listFloatPairParser =
    Parser.succeed identity
        |. Parser.symbol "["
        |. Parser.spaces
        |= manySeparatedBy2 "," floatPairParser
        |. Parser.spaces
        |. Parser.symbol "]"


floatPairParser : Parser ( Float, Float )
floatPairParser =
    Parser.succeed (\a b -> ( a, b ))
        |. Parser.symbol "("
        |. Parser.spaces
        |= floatParser_
        |. Parser.spaces
        |. Parser.symbol ","
        |. Parser.spaces
        |= floatParser_
        |. Parser.spaces
        |. Parser.symbol ")"


pairParser : Parser Value
pairParser =
    Parser.succeed (\a b -> Value.Tuple a b)
        |. Parser.symbol "("
        |. Parser.spaces
        |= valueParser
        |. Parser.spaces
        |. Parser.symbol ","
        |. Parser.spaces
        |= valueParser
        |. Parser.spaces
        |. Parser.symbol ")"


signedFloat : Parser Value
signedFloat =
    Parser.symbol "-" |> Parser.andThen (\_ -> Parser.float |> Parser.map (\f -> -f)) |> Parser.map Float


floatParser_ : Parser Float
floatParser_ =
    Parser.oneOf [ signedFloat_, Parser.float ]


signedFloat_ : Parser Float
signedFloat_ =
    Parser.symbol "-" |> Parser.andThen (\_ -> Parser.float |> Parser.map (\f -> -f))


listParser : Parser Value
listParser =
    Parser.symbol "["
        |> Parser.andThen (\_ -> Parser.lazy (\_ -> manySeparatedBy2 "," valueParser) |> Parser.map List)



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


manySeparatedBy2 : String -> Parser a -> Parser (List a)
manySeparatedBy2 sep p =
    Parser.loop [] (manySeparateByHelp2 sep p)


manySeparateByHelp : String -> Parser a -> List a -> Parser (Parser.Step (List a) (List a))
manySeparateByHelp sep p vs =
    Parser.oneOf
        [ Parser.succeed (\v -> Parser.Loop (v :: vs))
            |= p
            |. Parser.oneOf [ Parser.end, Parser.symbol sep, Parser.spaces |> Parser.andThen (\_ -> Parser.symbol "]") ]
            |. Parser.spaces
        , Parser.succeed ()
            |> Parser.map (\_ -> Parser.Done (List.reverse vs))
        ]


manySeparateByHelp2 : String -> Parser a -> List a -> Parser (Parser.Step (List a) (List a))
manySeparateByHelp2 sep p vs =
    Parser.oneOf
        [ Parser.succeed (\v -> Parser.Loop (v :: vs))
            |= p
            |. Parser.oneOf [ Parser.symbol sep, Parser.succeed () ]
            |. Parser.spaces
        , Parser.succeed ()
            |> Parser.map (\_ -> Parser.Done (List.reverse vs))
        ]



--- UNWRappers
--unwrapListTupleFloat : List (Tuple Float Float) -> List ( Float, Float )


unwrapListTupleFloat list =
    List.map unwrapTupleFloat list
        |> List.filterMap identity



--unwrapTupleFloat : Tuple Float Float -> ( Float, Float )


unwrapTupleFloat tuple =
    case tuple of
        Tuple (Float a) (Float b) ->
            Just ( a, b )

        _ ->
            Nothing
