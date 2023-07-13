module View.Footer exposing (view)

import Element as E exposing (Element)
import Element.Font as Font
import Predicate
import UILibrary.Color as Color
import View.Button as Button
import View.Geometry
import View.Input
import View.MarkdownThemed
import View.Popup.Admin
import View.Popup.EditDataSet
import View.Popup.Manual
import View.Popup.NewDataSet
import View.Popup.NewNotebook
import View.Popup.SignUp
import View.Popup.StateEditor
import View.Popup.ViewPrivateDataSets
import View.Popup.ViewPublicDataSets
import View.Style
import View.Utility


view model =
    E.row
        [ E.height (E.px View.Geometry.footerHeight)
        , E.width (E.px (View.Geometry.appWidth model))
        , Font.size 14
        , E.alignBottom
        , E.inFront (View.Popup.Admin.view model)
        , E.inFront (View.Popup.SignUp.view model)
        , E.inFront (View.Popup.NewNotebook.view model)
        , E.inFront (View.Popup.Manual.view model View.MarkdownThemed.lightTheme)
        , E.inFront (View.Popup.NewDataSet.view model)
        , E.inFront (View.Popup.ViewPublicDataSets.view model)
        , E.inFront (View.Popup.ViewPrivateDataSets.view model)
        , E.inFront (View.Popup.EditDataSet.view model)
        , E.inFront (View.Popup.StateEditor.view model)
        , View.Style.bgGray 0.0
        , E.spacing 12
        ]
        (case model.currentUser of
            Nothing ->
                [ View.Utility.showIfIsAdmin model (Button.adminPopup model)
                , View.Utility.showIfIsAdmin model Button.runTask
                , messageRow model
                ]

            Just _ ->
                [ View.Utility.showIfIsAdmin model (Button.adminPopup model)
                , View.Utility.showIfIsAdmin model Button.runTask
                , messageRow model
                , E.el [ Font.color (E.rgb 1 1 1) ] (E.text (String.fromInt <| List.length model.pressedKeys))
                , Button.newDataSet
                , Button.toggleViewPublicDataSets
                , Button.toggleViewPrivateDataSets
                , Button.getRandomProbabilities
                , case model.currentBook.origin of
                    Just origin ->
                        E.el [ E.alignRight, Font.color Color.lightGray ] (E.text <| origin)

                    Nothing ->
                        E.none
                , case model.currentBook.origin of
                    Just _ ->
                        E.el [ Font.color Color.lightGray ] (E.text " ==> ")

                    Nothing ->
                        E.none
                , E.el [ E.alignRight, Font.color Color.lightGray ] (E.text model.currentBook.slug)
                , Button.public model.currentBook
                , case model.currentBook.origin of
                    Just _ ->
                        E.el [ E.paddingEach { left = 24, right = 0, top = 0, bottom = 0 } ] Button.pullNotebook

                    Nothing ->
                        E.none
                , View.Utility.showIf (Predicate.canClone model) Button.cloneNotebook

                --, View.Input.cloneReference model
                ]
        )


messageRow model =
    E.row
        [ E.width (E.px 300)
        , E.height (E.px View.Geometry.footerHeight)
        , E.paddingXY View.Geometry.hPadding 4
        , View.Style.bgGray 0.1
        , Font.color (E.rgb 0 1 0)
        ]
        [ E.text <| model.message ]
