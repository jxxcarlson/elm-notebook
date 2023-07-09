module LiveBook.SVG exposing (render)

import Color exposing (Color)
import Element exposing (Element)
import Html exposing (Html)
import TypedSvg
import TypedSvg.Attributes exposing (cx, cy, fill, height, r, stroke, strokeWidth, viewBox, width, x, y)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Paint(..), px)


render : List String -> Element msg
render svgList =
    let
        _ =
            svgList

        foo : List (Svg msg)
        foo =
            List.map stringToSvg svgList
                |> List.filterMap identity
    in
    TypedSvg.svg [ viewBox 0 0 800 400 ] foo |> Element.html


type XSVG
    = Circle String String String String


stringToColor : String -> Color
stringToColor color =
    case color of
        "red" ->
            Color.red

        "blue" ->
            Color.blue

        "green" ->
            Color.green

        "yellow" ->
            Color.yellow

        "black" ->
            Color.black

        "white" ->
            Color.white

        _ ->
            Color.black


circle : String -> String -> String -> String -> Maybe (Svg msg)
circle cx1 cy1 r1 color =
    let
        cx2 =
            String.toFloat cx1

        cy2 =
            String.toFloat cy1

        r2 =
            String.toFloat r1
    in
    case ( cx2, cy2, r2 ) of
        ( Just cx3, Just cy3, Just r3 ) ->
            Just
                (TypedSvg.circle
                    [ cx (px cx3)
                    , cy (px cy3)
                    , r (px r3)
                    , fill <| Paint (stringToColor color)
                    ]
                    []
                )

        _ ->
            Nothing


rectangle : String -> String -> String -> String -> String -> Maybe (Svg msg)
rectangle cx1 cy1 w1 h1 color =
    let
        cx2 =
            String.toFloat cx1

        cy2 =
            String.toFloat cy1

        w2 =
            String.toFloat w1

        h2 =
            String.toFloat h1
    in
    case ( ( cx2, cy2 ), ( w2, h2 ) ) of
        ( ( Just cx3, Just cy3 ), ( Just w3, Just h3 ) ) ->
            Just
                (TypedSvg.rect
                    [ x (px cx3)
                    , y (px cy3)
                    , width (px w3)
                    , height (px h3)
                    , fill <| Paint (stringToColor color)
                    ]
                    []
                )

        _ ->
            Nothing


stringToSvg : String -> Maybe (Svg msg)
stringToSvg str =
    case String.words str of
        "circle" :: cx :: cy :: r :: color :: [] ->
            circle cx cy r color

        "square" :: cx :: cy :: r :: color :: [] ->
            rectangle cx cy r r color

        "rectangle" :: cx :: cy :: w :: h :: color :: [] ->
            rectangle cx cy w h color

        _ ->
            Nothing
