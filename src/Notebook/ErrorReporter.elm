module Notebook.ErrorReporter exposing
    ( MessageItem(..)
    , decodeErrorReporter
    , render
    , stringToMessageItem
    )

{-| This module contains the decoders for the error messages that the repl
-}

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Json.Decode as D
import List.Extra


type alias ReplError =
    { tipe : String
    , errors : List ErrorItem
    }


type alias ErrorItem =
    { path : String
    , name : String
    , problems : List Problem
    }


type alias Region =
    { start : Position
    , end : Position
    }


type alias Position =
    { line : Int
    , column : Int
    }


type alias Problem =
    { title : String
    , region : Region
    , message : List MessageItem
    }


type alias StyledString =
    { bold : Bool
    , underline : Bool
    , color : Maybe String
    , string : String
    }


renderMessageItem : MessageItem -> Element msg
renderMessageItem messageItem =
    case messageItem of
        Plain str ->
            -- el [] (text (str |> String.replace "\n" ""))
            el [] (text str)

        Styled styledString ->
            let
                color =
                    if String.contains "^" styledString.string then
                        Element.rgb 1.0 0 0

                    else
                        case styledString.color of
                            Nothing ->
                                Element.rgb 0.9 0 0.6

                            Just "red" ->
                                Element.rgb 1 0 0

                            Just "green" ->
                                Element.rgb 0 1 0

                            Just "blue" ->
                                Element.rgb 0 0 1

                            Just "yellow" ->
                                Element.rgb 1 1 0

                            Just "black" ->
                                Element.rgb 0.9 0.4 0.1

                            Just "white" ->
                                Element.rgb 1 1 1

                            _ ->
                                Element.rgb 0 1 0

                style =
                    if styledString.bold then
                        Font.bold

                    else if styledString.underline then
                        Font.underline

                    else
                        Font.unitalicized

                padding_ =
                    if String.contains "^" styledString.string then
                        paddingXY 15 8

                    else
                        paddingXY 8 8
            in
            el [ padding_, Font.color color, style ] (text styledString.string)


stringToMessageItem : String -> MessageItem
stringToMessageItem str =
    Plain str


type MessageItem
    = Plain String
    | Styled StyledString



-- decodeErrorReporter : String -> Result String ReplError


decodeErrorReporter str =
    D.decodeString replErrorDecoder str


replErrorDecoder : D.Decoder ReplError
replErrorDecoder =
    D.map2 ReplError
        (D.field "type" D.string)
        (D.field "errors" (D.list errorItemDecoder))


errorItemDecoder : D.Decoder ErrorItem
errorItemDecoder =
    D.map3 ErrorItem
        (D.field "path" D.string)
        (D.field "name" D.string)
        (D.field "problems" (D.list problemDecoder))


problemDecoder : D.Decoder Problem
problemDecoder =
    D.map3 Problem
        (D.field "title" D.string)
        (D.field "region" regionDecoder)
        (D.field "message" (D.list messageItemDecoder))


regionDecoder : D.Decoder Region
regionDecoder =
    D.map2 Region
        (D.field "start" positionDecoder)
        (D.field "end" positionDecoder)


positionDecoder : D.Decoder Position
positionDecoder =
    D.map2 Position
        (D.field "line" D.int)
        (D.field "column" D.int)


messageItemDecoder : D.Decoder MessageItem
messageItemDecoder =
    D.oneOf
        [ D.map Plain D.string
        , D.map Styled styledStringDecoder
        ]


styledStringDecoder : D.Decoder StyledString
styledStringDecoder =
    D.map4 StyledString
        (D.field "bold" D.bool)
        (D.field "underline" D.bool)
        (D.field "color" (D.nullable D.string))
        (D.field "string" D.string)


render report =
    if List.isEmpty report then
        Element.none

    else if report == [ Plain "Ok" ] then
        Element.none

    else
        column
            [ paddingXY 8 8
            , Font.color (rgb 0.9 0.9 0.9)
            , Font.size 14
            , width (px 600)
            , height (px 400)
            , scrollbarY
            , spacing 8
            , Background.color (rgb 0 0 0)
            ]
            (prepareReport report)


breakMessage : MessageItem -> List MessageItem
breakMessage messageItem =
    case messageItem of
        Plain str ->
            let
                parts =
                    String.split "\n" str

                n =
                    List.length parts

                prefix =
                    List.take (n - 1) parts |> List.map (\str_ -> Plain (str_ ++ "\n"))

                last =
                    List.drop (n - 1) parts |> List.map (\str_ -> Plain str_)
            in
            prefix ++ last

        Styled styledString ->
            [ Styled styledString ]


breakMessages : List MessageItem -> List MessageItem
breakMessages messageItems =
    messageItems
        |> List.map breakMessage
        |> List.concat


prepareReport : List MessageItem -> List (Element msg)
prepareReport report =
    let
        _ =
            Debug.log "REPORT" (breakMessages report)

        groups : List (List MessageItem)
        groups =
            groupMessageItemsHelp (breakMessages report)

        --_ =
        --    List.indexedMap (\index -> Debug.log ("GROUP " ++ String.fromInt (index + 1))) groups
        bar : List (Element msg)
        bar =
            groups
                |> List.map (List.map (\item -> renderMessageItem item))
                |> List.map (\group_ -> paragraph [] group_)

        --baz : Element msg
        --baz =
        --    column [] bar
    in
    bar


groupMessageItemsHelp : List MessageItem -> List (List MessageItem)
groupMessageItemsHelp messageItems =
    List.Extra.groupWhile grouper messageItems |> List.map (\( first, rest ) -> first :: rest)


{-| start new group on false
-}
grouper : MessageItem -> MessageItem -> Bool
grouper item1 item2 =
    case ( item1, item2 ) of
        ( Plain str, _ ) ->
            not <| String.contains "\n" str

        ( Styled _, _ ) ->
            True
