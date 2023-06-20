module View.Body exposing (..)

import Element as E exposing (Element)
import Element.Font as Font
import Types exposing (FrontendModel)
import User
import View.Geometry
import View.Style


view : FrontendModel -> User.User -> Element msg
view model user =
    E.column [ E.height (E.px (View.Geometry.mainColumnHeight model - 200)), E.centerX, E.centerY, E.spacing 18 ]
        [ E.paragraph
            [ View.Style.fgGray 0.6
            , Font.size 14
            , E.paddingEach { top = 19, bottom = 0, left = 0, right = 0 }
            , E.width (E.px (View.Geometry.appWidth model - 370))
            ]
            [ E.el [ E.centerX, E.centerY ] (E.text <| "Now signed in: " ++ user.username)
            ]
        ]
