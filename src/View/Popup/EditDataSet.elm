module View.Popup.EditDataSet exposing (..)

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
    case model.popupState of
        Types.EditDataSetPopup dataSetMetaData ->
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
                    (E.text "Edit Data Set")
                , View.Input.name model
                , View.Input.description model
                , View.Input.comments model
                , E.el [ Font.color UILibrary.Color.lightGray ] (E.text dataSetMetaData.identifier)
                , E.row [ E.spacing 24 ] [ View.Button.saveDataSetAsPrivate dataSetMetaData, View.Button.saveDataSetAsPublic dataSetMetaData ]
                , View.Button.deleteDataSet dataSetMetaData
                ]

        _ ->
            E.none
