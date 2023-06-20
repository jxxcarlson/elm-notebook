module View.BodyNotSignedIn exposing (..)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Types exposing (FrontendModel)
import View.Geometry
import View.Style


view : FrontendModel -> Element msg
view model =
    E.column [ E.height (E.px (View.Geometry.mainColumnHeight model - 200)), E.centerX, E.centerY, E.spacing 18 ]
        [ E.image [ E.height (E.px (View.Geometry.mainColumnHeight model - 300)), E.centerX, E.centerY ]
            { src = "https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/30f08d58-dbce-42a0-97a6-512735707700/public"
            , description = "bird"
            }
        , E.paragraph
            [ View.Style.fgGray 0.6
            , Font.size 14
            , E.paddingEach { top = 19, bottom = 0, left = 0, right = 0 }
            , E.centerX
            , E.width (E.px (View.Geometry.appWidth model - 370))
            ]
            [ E.text "Welcome to Elm Livebook"
            ]
        ]
