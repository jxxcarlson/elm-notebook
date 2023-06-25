module View.BodyNotSignedIn exposing (..)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Types exposing (FrontendModel)
import View.Geometry
import View.Style


view : FrontendModel -> Element msg
view model =
    E.column [ E.height (E.px (View.Geometry.mainColumnHeight model)), E.centerX, E.spacing 18 ]
        [ E.el [ Font.color (E.rgb 0.8 0.8 0.8), Font.size 32, E.centerX, E.paddingEach { left = 0, right = 0, top = 48, bottom = 24 } ] (E.text "Elm Livebook")
        , E.image [ E.height (E.px (View.Geometry.mainColumnHeight model - 310)), E.centerX, E.centerY ]
            { src = "https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/30f08d58-dbce-42a0-97a6-512735707700/public"
            , description = "bird"
            }
        , E.column
            [ View.Style.fgGray 0.6
            , Font.size 14
            , E.spacing 8
            , Font.color (E.rgb 0.9 0.9 0.9)
            , E.paddingEach { top = 19, bottom = 0, left = 0, right = 0 }
            , E.centerX
            , E.scrollbarY

            --, E.height (E.px (View.Geometry.mainColumnHeight model))
            , E.height (E.px 400)
            , E.width (E.px (min 500 (View.Geometry.appWidth model - 300)))
            ]
            [ E.paragraph [ E.spacing 8 ]
                [ E.text "Welcome to Elm Livebook — an app like Jupyter notebooks or Elixir's Livebook. "
                , E.text "Documents are made up of cells which contain both text and Elm code. "
                ]
            , E.row [ E.height (E.px 8) ] []
            , E.paragraph [ E.spacing 8 ]
                [ E.text "Please look at the manual before you start. (Click on 'Manual' button in header.) "
                , E.text "See also the public notebook 'Welcome to Elm Livebook'. "
                ]
            , E.row [ E.height (E.px 8) ] []
            , E.text "The engine that runs the app is @minibill's elm-interpreter. "
            ]
        ]
