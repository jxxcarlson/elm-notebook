module View.CellThemed exposing (bulletPoint, heading1, lightTheme, renderFull)

import Element exposing (..)
import Element.Background
import Element.Border
import Element.Font
import Element.Region
import Html
import Html.Attributes
import Markdown.Block exposing (HeadingLevel, ListItem(..))
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer


type alias Theme =
    { defaultText : Element.Color
    , mutedText : Element.Color
    , grey : Element.Color
    , lightGrey : Element.Color
    , codeBackground : Element.Color
    , codeColor : Element.Color
    , codeSpanColor : Element.Color
    , link : Element.Color
    , elmText : Element.Color
    , background : Element.Color
    }


lightTheme : Theme
lightTheme =
    { defaultText = Element.rgb255 30 46 50
    , mutedText = Element.rgb255 74 94 122
    , link = Element.rgb255 12 82 109
    , lightGrey = Element.rgb255 220 240 255
    , codeBackground = Element.rgb255 20 20 20
    , codeColor = Element.rgb255 255 180 50
    , codeSpanColor = Element.rgb255 180 50 255
    , grey = Element.rgb255 200 220 240
    , elmText = Element.rgb255 30 46 50
    , background = Element.rgb255 220 220 255
    }


renderFull : Int -> Int -> String -> Element msg
renderFull width_ height_ markdownBody =
    render (renderer lightTheme) width_ height_ markdownBody


render : Markdown.Renderer.Renderer (Element msg) -> Int -> Int -> String -> Element msg
render chosenRenderer width_ height_ markdownBody =
    Markdown.Parser.parse markdownBody
        -- @TODO show markdown parsing errors, i.e. malformed html?
        |> Result.withDefault []
        |> (\parsed ->
                parsed
                    |> Markdown.Renderer.render chosenRenderer
                    |> (\res ->
                            case res of
                                Ok elements ->
                                    elements

                                Err err ->
                                    [ Element.text "Something went wrong rendering this page"
                                    , Element.text err
                                    ]
                       )
                    |> Element.column
                        [ Element.width (Element.px width_)
                        , Element.Background.color lightTheme.background
                        , Element.height (Element.px <| height_)
                        , Element.paddingEach { left = 12, right = 12, top = 8, bottom = 12 }
                        , Element.scrollbarY
                        ]
           )


bulletPoint : List (Element msg) -> Element msg
bulletPoint children =
    Element.wrappedRow
        [ Element.spacing 5
        , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 20 }
        , Element.width Element.fill
        ]
        [ Element.paragraph
            [ Element.alignTop ]
            (Element.text " • " :: children)
        ]


renderer : Theme -> Markdown.Renderer.Renderer (Element msg)
renderer theme =
    { heading = \data -> Element.row [] [ heading theme data ]
    , paragraph =
        Element.paragraph
            [ Element.paddingEach { left = 0, right = 0, top = 0, bottom = 20 }
            ]
    , blockQuote =
        \children ->
            Element.column
                [ Element.Font.size 20
                , Element.Font.italic
                , Element.Border.widthEach { bottom = 0, left = 4, right = 0, top = 0 }
                , Element.Border.color theme.grey
                , Element.Font.color theme.mutedText
                , Element.padding 10
                ]
                children
    , html =
        Markdown.Html.oneOf
            [ Markdown.Html.tag "img"
                (\src width_ maxWidth_ bg_ content ->
                    let
                        attrs =
                            case maxWidth_ of
                                Just maxWidth ->
                                    [ maxWidth
                                        |> String.toInt
                                        |> Maybe.map (\w -> width (fill |> maximum w))
                                        |> Maybe.withDefault (width fill)
                                    , centerX
                                    ]

                                Nothing ->
                                    [ width_
                                        |> Maybe.andThen String.toInt
                                        |> Maybe.map (\w -> width (px w))
                                        |> Maybe.withDefault (width fill)
                                    ]
                    in
                    case bg_ of
                        Just bg ->
                            el [ Element.Border.rounded 10, padding 20 ] <| image attrs { src = src, description = "" }

                        Nothing ->
                            image attrs { src = src, description = "" }
                )
                |> Markdown.Html.withAttribute "src"
                |> Markdown.Html.withOptionalAttribute "width"
                |> Markdown.Html.withOptionalAttribute "maxwidth"
                |> Markdown.Html.withOptionalAttribute "bg"
            ]
    , text = \s -> Element.el [ Element.Font.color (Element.rgb 0.0 0.0 0.1) ] (Element.text s)
    , codeSpan =
        \content ->
            Element.el
                [ Element.Font.color theme.codeSpanColor
                , Element.Font.family [ Element.Font.monospace ]
                ]
                (Element.html (Html.code [] [ Html.text content ]))
    , strong = \list -> Element.paragraph [ Element.Font.bold ] list
    , emphasis = \list -> Element.paragraph [ Element.Font.italic ] list
    , hardLineBreak = Element.html (Html.br [] [])
    , link =
        \{ title, destination } list ->
            Element.link
                [ Element.Font.underline
                , Element.Font.color theme.link
                ]
                { url = destination
                , label =
                    case title of
                        Just title_ ->
                            Element.text title_

                        Nothing ->
                            Element.paragraph [] list
                }
    , image =
        \{ alt, src, title } ->
            let
                attrs =
                    [ title |> Maybe.map (\title_ -> Element.htmlAttribute (Html.Attributes.attribute "title" title_)) ]
                        |> justs
            in
            Element.image
                (attrs ++ [ Element.width (Element.px 300), Element.centerX ])
                { src = src
                , description = alt
                }
    , unorderedList =
        \items ->
            Element.column
                [ Element.spacing 15
                , Element.width Element.fill
                , Element.paddingEach { top = 0, right = 0, bottom = 40, left = 0 }
                ]
                (items
                    |> List.map
                        (\listItem ->
                            case listItem of
                                ListItem _ children ->
                                    Element.wrappedRow
                                        [ Element.spacing 5
                                        , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 20 }
                                        , Element.width Element.fill
                                        ]
                                        [ Element.paragraph
                                            [ Element.alignTop ]
                                            (Element.text " • " :: children)
                                        ]
                        )
                )
    , orderedList =
        \startingIndex items ->
            Element.column [ Element.spacing 15, Element.width Element.fill ]
                (items
                    |> List.indexedMap
                        (\index itemBlocks ->
                            Element.wrappedRow
                                [ Element.spacing 5
                                , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 20 }
                                , Element.width Element.fill
                                ]
                                [ Element.paragraph
                                    [ Element.alignTop ]
                                    (Element.text (String.fromInt (startingIndex + index) ++ ". ") :: itemBlocks)
                                ]
                        )
                )
    , codeBlock =
        \{ body } ->
            Element.el [ Element.width Element.fill, Element.paddingEach { left = 0, right = 0, bottom = 18, top = 0 } ]
                (Element.column
                    [ Element.Font.family [ Element.Font.monospace ]
                    , Element.Background.color theme.codeBackground
                    , Element.Font.color theme.codeColor
                    , Element.Border.rounded 5
                    , Element.padding 10
                    , Element.height (Element.px <| textHeight 14 -5 body)
                    , Element.width Element.fill
                    , Element.paddingEach { top = 12, bottom = 12, left = 12, right = 12 }
                    , Element.htmlAttribute (Html.Attributes.class "preserve-white-space")
                    , Element.scrollbarX
                    ]
                    [ Element.html (Html.text (String.trim body))
                    ]
                )
    , thematicBreak = Element.none
    , table = \children -> Element.column [ Element.width Element.fill ] children
    , tableHeader = \children -> Element.column [] children
    , tableBody = \children -> Element.column [] children
    , tableRow = \children -> Element.row [ Element.width Element.fill ] children
    , tableCell = \_ children -> Element.column [ Element.width Element.fill ] children
    , tableHeaderCell = \_ children -> Element.column [ Element.width Element.fill ] children
    , strikethrough = \children -> Element.paragraph [ Element.Font.strike ] children
    }


textHeight scale_ shiftUp str =
    (str |> String.lines |> List.length |> scale scale_) + shiftUp


scale : Float -> Int -> Int
scale factor x =
    round <| factor * toFloat x


heading1 : List (Element.Attr () msg)
heading1 =
    [ Element.Font.size 24
    , Element.Font.semiBold
    , Element.Font.color lightTheme.defaultText
    , Element.paddingEach { top = 36, right = 0, bottom = 30, left = 0 }
    ]


heading : Theme -> { level : HeadingLevel, rawText : String, children : List (Element msg) } -> Element msg
heading theme { level, rawText, children } =
    Element.paragraph
        ((case Markdown.Block.headingLevelToInt level of
            1 ->
                heading1

            2 ->
                [ Element.Font.color theme.elmText
                , Element.Font.size 18
                , Element.Font.extraBold
                , Element.paddingEach { top = 0, right = 0, bottom = 14, left = 0 }
                ]

            3 ->
                [ Element.Font.color theme.defaultText
                , Element.Font.size 16
                , Element.Font.medium
                , Element.paddingEach { top = 0, right = 0, bottom = 12, left = 0 }
                ]

            4 ->
                [ Element.Font.color theme.defaultText
                , Element.Font.size 14
                , Element.Font.medium
                , Element.paddingEach { top = 0, right = 0, bottom = 10, left = 0 }
                ]

            _ ->
                [ Element.Font.size 12
                , Element.Font.medium
                , Element.Font.center
                , Element.paddingXY 0 20
                ]
         )
            ++ [ Element.Region.heading (Markdown.Block.headingLevelToInt level)
               , Element.htmlAttribute
                    (Html.Attributes.attribute "name" (rawTextToId rawText))
               , Element.htmlAttribute
                    (Html.Attributes.id (rawTextToId rawText))
               ]
        )
        children


rawTextToId : String -> String
rawTextToId rawText =
    rawText
        |> String.toLower
        |> String.replace " " "-"
        |> String.replace "." ""


justs : List (Maybe a) -> List a
justs =
    List.foldl
        (\v acc ->
            case v of
                Just el ->
                    el :: acc

                Nothing ->
                    acc
        )
        []
