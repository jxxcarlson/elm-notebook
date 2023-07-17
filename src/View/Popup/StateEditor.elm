module View.Popup.StateEditor exposing (view)

import Color
import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Types exposing (FrontendModel, FrontendMsg)
import UILibrary.Color
import View.Button
import View.Geometry
import View.Input
import View.Style


view : FrontendModel -> Element FrontendMsg
view model =
    case model.popupState of
        Types.StateEditorPopup ->
            E.column
                [ E.spacing 18
                , Background.color UILibrary.Color.lightBlue
                , E.padding 24
                , E.centerX
                , E.width (E.px 550)
                , E.height (E.px 600)
                , E.moveUp (View.Geometry.appHeight model - 100 |> toFloat)
                ]
                [ E.el [ Font.size 24, E.paddingEach { bottom = 16, top = 0, left = 0, right = 0 } ] (E.text "State Editor")
                , View.Input.initialStateValue model
                , View.Input.valuesToKeep model
                , View.Input.fastTickInterval model
                , View.Input.stateExpr model
                , View.Input.stateBindings model
                , View.Input.stopExpression model
                , E.el [ E.paddingEach { top = 24, bottom = 0, left = 0, right = 0 } ] View.Button.setState
                ]

        _ ->
            E.none
