module View.Body exposing (view)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font as Font
import LiveBook.Cell
import Types exposing (FrontendModel, FrontendMsg)
import UILibrary.Color as Color
import User
import View.Button
import View.Color
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
        (E.el [ Font.color Color.white, E.paddingEach { left = 0, right = 0, bottom = 8, top = 0 } ] (E.text "Notebooks")
            :: List.map (View.Button.viewNotebookEntry model.currentBook) (List.sortBy (\b -> b.title) model.books)
        )


viewNotebookEntry : Types.Book -> Types.Book -> Element FrontendMsg
viewNotebookEntry currentBook book =
    if currentBook.id == book.id then
        E.el [ Font.color Color.paleGray, Font.underline ] (E.text book.title)

    else
        E.el [ Font.color Color.paleGray ] (E.text book.title)


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
            , E.paddingEach { top = 19, bottom = 0, left = 0, right = 0 }
            ]
            (List.map
                (LiveBook.Cell.view (View.Geometry.notebookWidth model) model.cellContent)
                model.currentBook.cells
            )
        ]



--view : Int -> String -> Cell -> Element FrontendMsg
--view width cellContents cell
-- view width cell cellContents
