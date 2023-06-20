module View.Popup.SignUp exposing (view)

import Element exposing (Element)
import Element.Background
import Message
import Types
import View.Button
import View.Geometry
import View.Input
import View.Style


view : Types.FrontendModel -> Element Types.FrontendMsg
view model =
    case model.popupState of
        Types.SignUpPopup ->
            Element.column
                [ Element.spacing 18
                , View.Style.bgGray 0.4
                , Element.padding 24
                , Element.alignRight
                , Element.moveUp (View.Geometry.appHeight model - 100 |> toFloat)
                ]
                [ View.Input.signupUsername model
                , View.Input.email model
                , View.Input.password model
                , View.Input.passwordAgain model
                , Element.row [ Element.spacing 18 ]
                    [ View.Button.setUpUser
                    , View.Button.dismissPopup
                    ]
                , Element.el [ Element.width Element.fill, Element.paddingXY 8 8, View.Style.bgGray 0 ] (Message.viewSmall 250 model)
                ]

        _ ->
            Element.none
