module View.Popup.ViewDataSets exposing (..)

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
    View.Utility.showIf (model.popupState == Types.ViewDataSetsPopup) <|
        E.column
            [ E.height (E.px 700)
            , E.width (E.px 720)
            , E.moveUp (toFloat <| View.Geometry.bodyHeight model)
            , E.moveRight 400
            , Background.color UILibrary.Color.darkerSteelGray
            , E.padding 40
            , E.spacing 12
            ]
            (List.map viewDataSetMeta model.dataSetMetaDataList)


viewDataSetMeta : LiveBook.DataSet.DataSetMetaData -> Element Types.FrontendMsg
viewDataSetMeta data =
    E.column []
        [ E.row [ Font.color UILibrary.Color.lightGray, E.spacing 12 ]
            [ E.el [ E.width (E.px 150) ] (E.text data.name)
            , E.el [ E.width (E.px 270), E.clipX ]
                (E.text (String.Extra.softEllipsis 30 data.description))
            , E.el [ E.width (E.px 100) ] (E.text data.author)
            , viewPublicSatus data.public
            ]
        ]


viewPublicSatus : Bool -> Element Types.FrontendMsg
viewPublicSatus public =
    if public then
        E.text "public"

    else
        E.text "private"
