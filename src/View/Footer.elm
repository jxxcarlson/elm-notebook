module View.Footer exposing (view)

import Element as E exposing (Element)
import Element.Font as Font
import View.Button as Button
import View.Geometry
import View.Popup.Admin
import View.Popup.SignUp
import View.Style
import View.Utility


view model =
    E.row
        [ E.paddingXY 0 8
        , E.height (E.px View.Geometry.footerHeight)
        , E.width (E.px (View.Geometry.appWidth model))
        , Font.size 14
        , E.inFront (View.Popup.Admin.view model)
        , E.inFront (View.Popup.SignUp.view model)
        , View.Style.bgGray 0.0
        , E.spacing 12
        ]
        [ View.Utility.showIfIsAdmin model (Button.adminPopup model)
        , View.Utility.showIfIsAdmin model Button.runTask
        , messageRow model
        ]


messageRow model =
    E.row
        [ E.width E.fill
        , E.height (E.px View.Geometry.footerHeight)
        , E.paddingXY View.Geometry.hPadding 4
        , View.Style.bgGray 0.1
        , Font.color (E.rgb 0 1 0)
        ]
        [ E.text <| "Messages: " ++ model.message ]
