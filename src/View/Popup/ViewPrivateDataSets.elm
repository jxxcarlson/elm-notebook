module View.Popup.ViewPrivateDataSets exposing (..)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import LiveBook.DataSet
import String.Extra
import Types
import UILibrary.Color
import View.Button
import View.Geometry
import View.Input
import View.Utility


view : Types.FrontendModel -> Element Types.FrontendMsg
view model =
    View.Utility.showIf (model.popupState == Types.ViewPrivateDataSetsPopup) <|
        E.column
            [ E.height (E.px 700)
            , E.width (E.px 720)
            , E.moveUp (toFloat <| View.Geometry.bodyHeight model)
            , E.moveRight 400
            , Background.color UILibrary.Color.darkerSteelGray
            , E.padding 40
            , E.spacing 12
            ]
            (E.el [ Font.color (E.rgb 0.8 0.8 1.0) ] (E.text "My Datasets")
                :: List.map viewDataSetMeta model.privateDataSetMetaDataList
            )


viewDataSetMeta : LiveBook.DataSet.DataSetMetaData -> Element Types.FrontendMsg
viewDataSetMeta data =
    E.column []
        [ E.row [ Font.color UILibrary.Color.lightGray, E.spacing 12 ]
            [ E.el [ E.width (E.px 150) ] (E.text data.name)
            , E.el [ E.width (E.px 270), E.clipX ]
                (E.text (String.Extra.softEllipsis 45 data.description))
            , viewPublicSatus data.public
            , View.Button.editDataSet data
            ]
        ]


viewPublicSatus : Bool -> Element Types.FrontendMsg
viewPublicSatus public =
    if public then
        E.text "public"

    else
        E.text "private"
