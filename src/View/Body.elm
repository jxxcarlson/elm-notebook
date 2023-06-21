module View.Body exposing (..)

import Element as E exposing (Element)
import Element.Font as Font
import LiveBook.Cell
import Types exposing (FrontendModel, FrontendMsg)
import User
import View.Geometry
import View.Style


view : FrontendModel -> User.User -> Element FrontendMsg
view model user =
    E.column
        [ E.paddingEach { left = 48, right = 0, top = 0, bottom = 0 }
        , E.spacing 18
        ]
        [ E.column
            [ View.Style.fgGray 0.6
            , Font.size 14
            , E.height (E.px (View.Geometry.mainColumnHeight model))
            , E.scrollbarY
            , E.spacing 12
            , E.paddingEach { top = 19, bottom = 0, left = 0, right = 0 }
            ]
            (List.map
                (LiveBook.Cell.view (View.Geometry.appWidth model - 100) model.cellContent)
                model.currentBook.cells
            )
        ]



--view : Int -> String -> Cell -> Element FrontendMsg
--view width cellContents cell
-- view width cell cellContents
