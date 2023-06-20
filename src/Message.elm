module Message exposing (viewSmall)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Types
import View.Color
import View.Style


viewSmall : Int -> Types.FrontendModel -> Element Types.FrontendMsg
viewSmall width model =
    let
        actualMessages =
            model.messages |> List.filter (\m -> List.member m.status messageTypes)

        messageTypes =
            if model.showEditor then
                [ Types.MSGreen

                --, Types.MSYellow
                , Types.MSRed
                ]

            else
                [ Types.MSGreen, Types.MSRed ]
    in
    if actualMessages == [] then
        E.none

    else
        E.paragraph
            [ E.width (E.px width)

            --, E.height (E.px 20)
            , E.paddingXY 8 0
            , View.Style.bgGray 0.0
            , View.Style.fgGray 1.0
            , E.spacing 12
            , Font.size 12
            ]
            (actualMessages |> List.map handleMessageInFooter)


view : Types.FrontendModel -> Element Types.FrontendMsg
view model =
    let
        messageTypes =
            if model.showEditor then
                [ Types.MSGreen

                --, Types.MSYellow
                , Types.MSRed
                ]

            else
                [ Types.MSGreen, Types.MSRed ]
    in
    E.row
        [ E.width E.fill
        , E.height (E.px 30)
        , E.paddingXY 8 4
        , View.Style.bgGray 0.1
        , View.Style.fgGray 1.0
        , E.spacing 12
        ]
        (model.messages |> List.filter (\m -> List.member m.status messageTypes) |> List.map handleMessageInFooter)


style : List (E.Attr decorative msg) -> List (E.Attr decorative msg)
style attr =
    [ Font.size 14 ] ++ attr


make : String -> Types.MessageStatus -> List Types.Message
make str status =
    [ { txt = str, status = status } ]


handleMessage : Types.Message -> Element msg
handleMessage { txt, status } =
    case status of
        Types.MSWhite ->
            E.el (style []) (E.text txt)

        Types.MSYellow ->
            E.el (style [ Font.color View.Color.yellow ]) (E.text txt)

        Types.MSGreen ->
            E.el (style [ Font.color (E.rgb 0 0.7 0) ]) (E.text txt)

        Types.MSRed ->
            E.el (style [ Font.color View.Color.darkRed, E.paddingXY 4 4 ]) (E.text txt)


handleMessageInFooter : Types.Message -> Element msg
handleMessageInFooter { txt, status } =
    case status of
        Types.MSWhite ->
            E.el (style []) (E.text txt)

        Types.MSYellow ->
            E.el (style [ Font.color View.Color.yellow ]) (E.text txt)

        Types.MSGreen ->
            E.el (style [ Font.color (E.rgb 0 0.7 0) ]) (E.text txt)

        Types.MSRed ->
            E.el (style [ Font.color View.Color.red, E.paddingXY 4 4 ]) (E.text txt)
