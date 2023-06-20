module View.Main exposing (view)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Message
import Types exposing (..)
import UILibrary.Color as Color
import View.Body
import View.BodyNotSignedIn
import View.Color
import View.Footer
import View.Geometry
import View.Header
import View.Style
import View.Utility


type alias Model =
    FrontendModel


view : Model -> Html FrontendMsg
view model =
    E.layoutWith { options = [ E.focusStyle View.Utility.noFocus ] }
        [ View.Style.bgGray 0.2, E.clipX, E.clipY, E.height (E.px (View.Geometry.appHeight model)) ]
        (mainColumn model)


mainColumn : Model -> Element FrontendMsg
mainColumn model =
    E.column (mainColumnStyle model)
        [ View.Header.view model
        , case model.currentUser of
            Nothing ->
                View.BodyNotSignedIn.view model

            Just user ->
                View.Body.view model user
        , View.Footer.view model
        ]


mainColumnStyle model =
    [ E.centerX
    , E.centerY
    , Background.color Color.paleWarm
    , E.width (E.px <| View.Geometry.appWidth model)
    , E.height (E.px (View.Geometry.appHeight model))
    ]


title : String -> Element msg
title str =
    E.row [ E.centerX, View.Style.bgGray 0.9 ] [ E.text str ]
