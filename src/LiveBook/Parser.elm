module LiveBook.Parser exposing (..)

import Parser exposing ((|.), (|=), Parser)
import Value exposing (Value(..))


parse : String -> Maybe Value
parse str =
    Parser.run valueParser str
        |> Result.toMaybe


{-|

    > parse "1.2"
    Just (Float 1.2)

    > parse "[1.1, 2.2]"
    Just (List [Float 1.1,Float 2.2])

    > parse "[[1.1, 2.2], [7,8]]"
    Just (List [List [Float 1.1,Float 2.2],List [Float 7,Float 8]])

-}
valueParser : Parser Value
valueParser =
    Parser.oneOf
        [ Parser.lazy (\_ -> pairParser)
        , signedFloat
        , Parser.float |> Parser.map Float
        , listParser
        ]


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


listParser : Parser Value
listParser =
    Parser.symbol "["
        |> Parser.andThen (\_ -> Parser.lazy (\_ -> manySeparatedBy "," valueParser) |> Parser.map List)



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
