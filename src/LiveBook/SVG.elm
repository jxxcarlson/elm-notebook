module LiveBook.SVG exposing (render)

import Color exposing (Color)
import Element exposing (Element)
import Html exposing (Html)
import TypedSvg
import TypedSvg.Attributes exposing (cx, cy, fill, r, stroke, strokeWidth, viewBox)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Paint(..), px)


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


stringToSvg : String -> Maybe (Svg msg)
stringToSvg str =
    case String.words str of
        "circle" :: cx :: cy :: r :: color :: [] ->
            circle cx cy r color

        _ ->
            Nothing


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
    TypedSvg.svg [ viewBox 0 0 800 500 ] foo |> Element.html
