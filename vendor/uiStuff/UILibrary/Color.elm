module UILibrary.Color exposing
    ( black
    , blueExample
    , darkBlue
    , darkGray
    , darkGreen
    , darkRed
    , darkSteelGray
    , darkerSteelGray
    , grayExample
    , greenExample
    , lightBlue
    , lightGray
    , medBlue
    , mediumGray
    , paleBlue
    , paleGray
    , paleWarm
    , pink
    , redExample
    , specialBlue
    , stillDarkerSteelGray
    , transparent
    , veryPaleBlue
    , white
    )

import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font


paleWarm =
    --nElement.rgb255 255 250 227
    Element.rgb 1.0 0.95 0.95



--paleWarm =
--    Element.rgb255 250 240 212


paleCool =
    Element.rgb255 212 240 250



-- GRAYS


grayExample =
    Element.row [ Element.spacing 24 ]
        [ Element.el [ Font.size 14, Element.padding 12, Font.color paleGray, Background.color black ] (Element.text "paleGray on black")
        , Element.el [ Font.size 14, Element.padding 12, Font.color white, Background.color darkGray ] (Element.text "white on darkGray")
        , Element.el [ Font.size 14, Element.padding 12, Font.color white, Background.color mediumGray ] (Element.text "white on medimGray")
        , Element.el [ Font.size 14, Element.padding 12, Font.color black, Background.color lightGray ] (Element.text "black on lightGray")
        , Element.el [ Font.size 14, Element.padding 12, Font.color black, Background.color paleGray ] (Element.text "black on paleGray")
        ]


gray : Float -> Element.Color
gray g =
    Element.rgb g g g


white : Element.Color
white =
    gray 1.0


paleGray : Element.Color
paleGray =
    gray 0.8


lightGray : Element.Color
lightGray =
    gray 0.75


darkSteelGray =
    Element.rgb255 73 78 89


darkerSteelGray =
    Element.rgb255 63 68 79


stillDarkerSteelGray =
    Element.rgb255 43 48 62


mediumGray : Element.Color
mediumGray =
    gray 0.3


darkGray : Element.Color
darkGray =
    gray 0.2


black : Element.Color
black =
    gray 0.0



-- REDS


redExample =
    Element.row [ Element.spacing 24 ]
        [ Element.el [ Font.size 14, Element.padding 12, Font.color white, Background.color darkRed ] (Element.text "white on green")
        , Element.el [ Font.size 14, Element.padding 12, Font.color white, Background.color red ] (Element.text "white on red")
        , Element.el [ Font.size 14, Element.padding 12, Font.color white, Background.color mediumRed ] (Element.text "white on mediumRed")
        , Element.el [ Font.size 14, Element.padding 12, Font.color black, Background.color pink ] (Element.text "black on pink")
        ]


darkRed : Element.Color
darkRed =
    Element.rgb255 110 0 0


darkGreen : Element.Color
darkGreen =
    Element.rgb255 0 110 0


red : Element.Color
red =
    Element.rgb 1 0 0


mediumRed : Element.Color
mediumRed =
    Element.rgb 1 0.5 0.5


pink : Element.Color
pink =
    Element.rgb 1.0 0.8 0.8



-- GREENS


greenExample =
    Element.row [ Element.spacing 24 ]
        [ Element.el [ Font.size 14, Element.padding 12, Font.color white, Background.color darkGreen ] (Element.text "white on darkGreen")
        , Element.el [ Font.size 14, Element.padding 12, Font.color black, Background.color green ] (Element.text "black on green")
        , Element.el [ Font.size 14, Element.padding 12, Font.color black, Background.color mediumGreen ] (Element.text "black on mediumGreen")
        , Element.el [ Font.size 14, Element.padding 12, Font.color black, Background.color paleGreen ] (Element.text "black on paleGreen")
        ]


green : Element.Color
green =
    Element.rgb 0 1 0


mediumGreen : Element.Color
mediumGreen =
    Element.rgb 0.5 1 0.5


paleGreen : Element.Color
paleGreen =
    Element.rgb 0.8 1 0.8



-- BLUES


blueExample =
    Element.row [ Element.spacing 24 ]
        [ Element.el [ Font.size 14, Element.padding 12, Font.color white, Background.color darkBlue ] (Element.text "white on darkBlue")
        , Element.el [ Font.size 14, Element.padding 12, Font.color white, Background.color blue ] (Element.text "white on blue")
        , Element.el [ Font.size 14, Element.padding 12, Font.color black, Background.color mediumBlue ] (Element.text "black on mediumBlue")
        , Element.el [ Font.size 14, Element.padding 12, Font.color black, Background.color paleBlue ] (Element.text "black on paleBlue")
        ]


darkBlue : Element.Color
darkBlue =
    Element.rgb255 0 0 140


blue : Element.Color
blue =
    Element.rgb 0 0 1


mediumBlue : Element.Color
mediumBlue =
    Element.rgb 0.5 0.5 1


lightBlue : Element.Color
lightBlue =
    Element.rgb255 207 205 250


specialBlue : Element.Color
specialBlue =
    Element.rgb255 100 130 255


medBlue : Element.Color
medBlue =
    Element.rgb255 97 92 247


paleBlue : Element.Color
paleBlue =
    Element.rgb255 226 225 252


veryPaleBlue : Element.Color
veryPaleBlue =
    Element.rgb 0.9 0.9 1.0


transparent : Element.Color
transparent =
    Element.rgba 0 0 0 0



-- paleGreen =
--     Element.rgb 230 230 255
-- white : Element.Color
-- white =
--     Element.rgb 255 255 255
-- palePink =
--     Element.rgb 1.0 0.9 0.93
-- lightGray : Element.Color
-- lightGray =
--     gray 0.9
-- medGray : Element.Color
-- medGray =
--     gray 0.5
-- darkGray : Element.Color
-- darkGray =
--     gray 0.3
-- black : Element.Color
-- black =
--     gray 0.2
-- red : Element.Color
-- red =
--     Element.rgb255 255 0 0
-- paleRed : Element.Color
-- paleRed =
--     Element.rgb255 140 100 100
-- blue : Element.Color
-- blue =
--     Element.rgb255 0 0 140
-- darkBlue : Element.Color
-- darkBlue =
--     Element.rgb255 0 0 120
-- lightBlue : Element.Color
-- lightBlue =
--     Element.rgb255 120 120 200
-- yellow =
--     Element.rgb 0.8 0.8 0
-- mediumBlue : Element.Color
-- mediumBlue =
--     Element.rgb255 80 80 255
-- paleBlue : Element.Color
-- paleBlue =
--     Element.rgb255 180 180 255
-- veryPaleBlue : Element.Color
-- veryPaleBlue =
--     Element.rgb 0.9 0.9 1.0
-- mediumPaleBlue : Element.Color
-- mediumPaleBlue =
--     Element.rgb 0.85 0.85 1.0
-- transparentBlue : Element.Color
-- transparentBlue =
--     Element.rgba 0.9 0.9 1 0.9
-- paleViolet : Element.Color
-- paleViolet =
--     Element.rgb255 230 230 255
-- violet : Element.Color
-- violet =
--     Element.rgb 0.95 0.9 1.0
-- gray : Float -> Element.Color
-- gray g =
--     Element.rgb g g g
-- green : Element.Color
-- green =
--     Element.rgb 0 1 0
