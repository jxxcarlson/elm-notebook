module View.Popup.NewNotebook exposing (view)

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
        Types.NewNotebookPopup ->
            Element.column
                [ Element.spacing 18
                , View.Style.bgGray 0.4
                , Element.padding 24
                , Element.alignRight
                , Element.moveUp (View.Geometry.appHeight model - 100 |> toFloat)
                ]
                [ Element.text "New Notebbok" -- View.Input.title model
                ]

        _ ->
            Element.none
