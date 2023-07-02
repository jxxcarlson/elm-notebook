module View.Body exposing (view)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font as Font
import LiveBook.Types exposing (Book)
import LiveBook.View
import Types exposing (FrontendModel, FrontendMsg)
import UILibrary.Color as Color
import User
import Util
import View.Button
import View.Geometry
import View.Style


view : FrontendModel -> User.User -> Element FrontendMsg
view model user =
    E.row
        [ E.width (E.px (View.Geometry.appWidth model))
        , E.height (E.px (View.Geometry.bodyHeight model))
        , E.padding 0
        ]
        [ viewNotebook model user
        , viewNotebookList model user
        ]


viewNotebookList : FrontendModel -> User.User -> Element FrontendMsg
viewNotebookList model user =
    E.column
        [ E.spacing 1
        , E.alignTop
        , Font.size 14
        , E.width (E.px (View.Geometry.notebookListWidth - 46))
        , Element.Border.widthEach { left = 1, right = 0, top = 0, bottom = 1 }
        , Element.Border.color Color.stillDarkerSteelGray
        , Background.color (E.rgb255 73 78 89)
        , E.height (E.px (View.Geometry.bodyHeight model))
        , E.paddingXY 24 12
        ]
        (case model.showNotebooks of
            Types.ShowUserNotebooks ->
                viewMyNotebookList model user

            Types.ShowPublicNotebooks ->
                viewPublicNotebookList model user
        )


viewMyNotebookList : FrontendModel -> User.User -> List (Element FrontendMsg)
viewMyNotebookList model user =
    E.el [ Font.color Color.white, E.paddingEach { left = 0, right = 0, bottom = 8, top = 0 } ]
        (E.text <| "Notebooks: " ++ String.fromInt (List.length model.books))
        :: controls model.showNotebooks
        :: List.map (viewNotebookEntry model.currentBook) (List.sortBy (\b -> b.title) model.books)


viewNotebookEntry : Book -> Book -> Element FrontendMsg
viewNotebookEntry currentBook book =
    E.row []
        [ View.Button.viewNotebookEntry currentBook book
        , case book.origin of
            Nothing ->
                E.none

            Just origin ->
                case Util.firstPart origin of
                    Nothing ->
                        E.none

                    Just username ->
                        E.el [ Font.color Color.lightGray, E.paddingXY 0 8, E.width (E.px 80) ] (E.text <| " (" ++ username ++ ")")
        ]


viewPublicNotebookList model user =
    E.el [ Font.color Color.white, E.paddingEach { left = 0, right = 0, bottom = 8, top = 0 } ]
        (E.text <| "Notebooks: " ++ String.fromInt (List.length model.books))
        :: controls model.showNotebooks
        :: List.map (viewPublicNotebookEntry model.currentBook) (List.sortBy (\b -> b.author ++ b.title) model.books)


viewPublicNotebookEntry : Book -> Book -> Element FrontendMsg
viewPublicNotebookEntry currentBook book =
    E.row []
        [ E.el [ Font.color Color.lightGray, E.paddingXY 0 8, E.width (E.px 80) ] (E.text book.author)
        , View.Button.viewNotebookEntry currentBook book
        ]


controls : Types.ShowNotebooks -> Element FrontendMsg
controls showNotebooks =
    E.row [ E.spacing 12 ]
        [ View.Button.myNotebooks showNotebooks
        , E.el [ E.paddingXY 0 8 ] (View.Button.publicNotebooks showNotebooks)
        ]


viewNotebook : FrontendModel -> User.User -> Element FrontendMsg
viewNotebook model user =
    E.column
        [ E.paddingEach { left = 24, right = 24, top = 20, bottom = 0 }
        , E.spacing 18
        ]
        [ E.column
            [ View.Style.fgGray 0.6
            , Font.size 14
            , E.height (E.px (View.Geometry.bodyHeight model))
            , E.width (E.px (View.Geometry.notebookWidth model))
            , E.scrollbarY
            , E.clipX
            , E.spacing 24
            , E.paddingEach { top = 19, bottom = 48, left = 0, right = 0 }
            ]
            (List.map
                (LiveBook.View.view model.kvDict (View.Geometry.notebookWidth model) model.cellContent)
                model.currentBook.cells
            )
        ]
