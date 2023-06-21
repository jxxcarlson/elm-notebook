module View.BodyNotSignedIn exposing (..)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Types exposing (FrontendModel)
import View.Geometry
import View.Style


view : FrontendModel -> Element msg
view model =
    E.column [ E.height (E.px (View.Geometry.mainColumnHeight model - 200)), E.centerX, E.spacing 18 ]
        [ E.el [ Font.size 32, E.centerX, E.paddingEach { left = 0, right = 0, top = 48, bottom = 24 } ] (E.text "Elm Livebook")
        , E.image [ E.height (E.px (View.Geometry.mainColumnHeight model - 400)), E.centerX, E.centerY ]
            { src = "https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/30f08d58-dbce-42a0-97a6-512735707700/public"
            , description = "bird"
            }
        , E.column
            [ View.Style.fgGray 0.6
            , Font.size 14
            , E.spacing 8
            , Font.color (E.rgb 0.2 0.2 0.2)
            , E.paddingEach { top = 19, bottom = 0, left = 0, right = 0 }
            , E.centerX
            , E.width (E.px (View.Geometry.appWidth model - 370))
            ]
            [ E.paragraph [ E.spacing 8 ]
                [ E.text "Welcome to Elm Livebook! There is much work to be done — "
                , E.text "and hopefully much more can be done before Elm Camp starts. "
                , E.text "@minibill's elm-interpreter is the key to the whole thing, and it has now been wired in, so we have a proof of concept. "
                ]
            , E.row [ E.height (E.px 18) ] []
            , E.paragraph [ E.spacing 8 ]
                [ E.text "There is much to do besides the usual fixing of bugs and tuning the UI, e.g.,  CRUD for notebooks. "
                , E.text "Especially vexing is an authentication bug that appears rondomly on sign up.  It needs to be fixed. "
                , E.text "If you want to help, please reach out to me on Slack (jxxcarlson). "
                ]
            ]
        ]
