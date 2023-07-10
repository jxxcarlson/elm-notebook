module LiveBook.State exposing
    ( NBValue(..)
    , getValue
    , parse
    , setValue
    , unwrapFloat
    , unwrapListFloat
    , updateKVDictWithValue
    )

import Dict exposing (Dict)
import Parser exposing ((|.), (|=), Parser)


type NBValue
    = NBFloat Float
    | NBFloatList (List Float)
    | NBList (List NBValue)
    | NBPoint Point



---setValueFromFloats : List Float -> FrontendModel -> FrontendModel


setValueFromFloats : List Float -> TinyModel a -> TinyModel a
setValueFromFloats floats model =
    setValue (List.map String.fromFloat floats) model


type alias TinyModel a =
    { a | kvDict : Dict String String, valueDict : Dict String NBValue }


getValue : String -> TinyModel a -> Maybe NBValue
getValue name model =
    Dict.get name model.valueDict


setValue : List String -> TinyModel a -> TinyModel a
setValue commandWords_ model =
    case commandWords_ of
        "setValue" :: name :: tail ->
            let
                value : Maybe NBValue
                value =
                    tail
                        |> String.join " "
                        |> parse
                        |> Debug.log "@@VALUE"

                valueDict =
                    case value of
                        Nothing ->
                            model.valueDict |> Debug.log "@@VALUE DICT (1)"

                        Just value_ ->
                            Dict.insert name value_ model.valueDict |> Debug.log "@@VALUE DICT (2)"
            in
            { model
                | valueDict = valueDict
            }

        _ ->
            model


updateKVDictWithValue : NBValue -> Dict String String -> Dict String String
updateKVDictWithValue value kvDict =
    case value of
        NBList [ NBFloat x, NBFloat y ] ->
            kvDict |> Dict.insert "xValue" (String.fromFloat x) |> Dict.insert "yValue" (String.fromFloat y)

        _ ->
            kvDict


unwrapFloat : NBValue -> Maybe Float
unwrapFloat value =
    case value of
        NBFloat float ->
            Just float

        _ ->
            Nothing


unwrapListFloat : NBValue -> Maybe (List Float)
unwrapListFloat value =
    case value of
        NBList list ->
            List.map unwrapFloat list |> List.filterMap identity |> Just

        _ ->
            Nothing


unwrapPoint : NBValue -> Maybe Point
unwrapPoint value =
    case value of
        NBPoint point ->
            Just point

        _ ->
            Nothing


parse : String -> Maybe NBValue
parse str =
    Parser.run parserIMValue str
        |> Result.toMaybe


{-|

    > parse "{x = 1, y = 2}"
    Just (IMPoint { x = 1, y = 2 })

    > parse "1.234"
    Ok (IMFloat 1.234)

> parse "[1, 2]"
> Just (IMFloatList [1,2])

> parse "L[1,2]"
> Just (IMList [IMFloat 1,IMFloat 2])

> parse "L[[1,2],[3,4]]"
> Just (IMList [IMFloatList [1,2],IMFloatList [3,4]])

-}
parserIMValue : Parser NBValue
parserIMValue =
    Parser.oneOf
        [ Parser.float |> Parser.map NBFloat
        , listParser
        , floatListParser
        , pointParser |> Parser.map NBPoint
        ]


floatListParser : Parser NBValue
floatListParser =
    Parser.symbol "["
        |> Parser.andThen (\_ -> Parser.lazy (\_ -> manySeparatedBy "," Parser.float) |> Parser.map NBFloatList)


listParser : Parser NBValue
listParser =
    Parser.symbol "L["
        |> Parser.andThen (\_ -> Parser.lazy (\_ -> manySeparatedBy "," parserIMValue) |> Parser.map NBList)



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
