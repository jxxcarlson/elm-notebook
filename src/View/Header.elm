module View.Header exposing (view)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font as Font
import Message
import Types exposing (AppMode(..))
import UILibrary.Color as Color
import View.Button as Button
import View.Color
import View.Geometry
import View.Input
import View.Style


view model =
    case model.currentUser of
        Nothing ->
            notSignedInHeader model

        Just user ->
            signedInHeader model user


notSignedInHeader model =
    E.row
        [ E.spacing 24
        , Font.size 14
        , E.height (E.px View.Geometry.headerHeight)
        , E.paddingXY View.Geometry.hPadding 0
        , Background.color Color.darkerSteelGray
        , Element.Border.widthEach { left = 0, right = 0, top = 0, bottom = 1 }
        , Element.Border.color Color.stillDarkerSteelGray
        , E.width (E.px (View.Geometry.appWidth model))
        ]
        [ E.row
            [ E.spacing 12
            ]
            [ View.Input.username model
            , View.Input.password model
            , Button.signIn
            ]
        , E.el [ E.alignRight ] Button.signUp
        ]


signedInHeader model user =
    E.row
        [ E.spacing 24
        , E.paddingXY View.Geometry.hPadding 0
        , E.spacing 24
        , E.height (E.px View.Geometry.headerHeight)
        , E.width (E.px <| View.Geometry.appWidth model)
        , Background.color Color.darkSteelGray
        , Element.Border.widthEach { left = 0, right = 0, top = 0, bottom = 1 }
        , Element.Border.color Color.stillDarkerSteelGray
        ]
        [ title "Elm Livebook"
        , if model.appMode == AMEditTitle then
            View.Input.title model

          else
            title model.currentBook.title
        , Button.editTitle model.appMode
        , Button.newNotebook

        --, E.el [ E.width E.fill, E.paddingXY 12 0 ] (Message.viewSmall 400 model)
        , E.el [ E.alignRight ] (Button.signOut user.username)
        ]


title : String -> Element msg
title str =
    E.el [ Font.size 18, Font.color View.Color.white ] (E.text str)
