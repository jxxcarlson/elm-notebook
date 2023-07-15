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
                , E.height (E.px 500)
                , E.moveUp (View.Geometry.appHeight model - 100 |> toFloat)
                ]
                [ E.text "Model Editor" -- View.Input.title model
                , View.Input.initialStateValue model
                , View.Input.fastTickInterval model
                , View.Input.stateExpr model
                , View.Input.stateBindings model
                , View.Input.stopExpressin model
                , View.Button.setState
                ]

        _ ->
            E.none
