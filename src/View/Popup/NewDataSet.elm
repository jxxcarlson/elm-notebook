module View.Popup.NewDataSet exposing (..)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Types
import UILibrary.Color
import View.Button
import View.Geometry
import View.Input
import View.Utility


view : Types.FrontendModel -> Element Types.FrontendMsg
view model =
    View.Utility.showIf (model.popupState == Types.NewDataSetPopup) <|
        E.column
            [ E.height (E.px 700)
            , E.width (E.px 380)
            , E.moveUp (toFloat <| View.Geometry.bodyHeight model)
            , E.moveRight 400
            , Background.color UILibrary.Color.darkerSteelGray
            , E.padding 40
            , E.spacing 12
            ]
            [ E.el
                [ Font.color UILibrary.Color.lightGray
                , Font.size 18
                , E.paddingEach { top = 0, bottom = 12, left = 0, right = 0 }
                ]
                (E.text "New Data Set")
            , View.Input.name model
            , View.Input.description model
            , View.Input.comments model
            , View.Input.data model
            , View.Button.createDataSet
            ]
