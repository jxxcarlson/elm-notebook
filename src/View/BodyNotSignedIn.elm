module View.BodyNotSignedIn exposing (..)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Types exposing (FrontendModel)
import UILibrary.Color
import View.Geometry
import View.Style


view : FrontendModel -> Element msg
view model =
    E.column [ E.height (E.px (View.Geometry.mainColumnHeight model)), E.centerX, E.spacing 18 ]
        [ E.el [ Font.color (E.rgb 0.8 0.8 0.8), Font.size 24, E.centerX, E.paddingEach { left = 0, right = 0, top = 24, bottom = 8 } ] (E.text "Elm Notebook")
        , E.column [ E.spacing 4 ]
            [ E.image [ E.width (E.px 600), E.centerX, E.centerY ]
                { src = "https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/7cdb9fb5-7383-4dc8-5831-1ad36a4dbf00/public"
                , description = "Cells in Elm Notebook"
                }
            , E.el [ Font.size 12, Font.color UILibrary.Color.lightGray ] (E.text "Screenshot of Elm Notebook")
            ]
        , E.column
            [ View.Style.fgGray 0.6
            , Font.size 14
            , E.spacing 8
            , Font.color (E.rgb 0.9 0.9 0.9)
            , E.paddingEach { top = 12, bottom = 0, left = 0, right = 0 }
            , E.centerX
            , E.scrollbarY

            --, E.height (E.px (View.Geometry.mainColumnHeight model))
            , E.height (E.px 600)
            , E.width (E.px (min 600 (View.Geometry.appWidth model - 300)))
            ]
            [ E.paragraph [ E.spacing 8 ]
                [ E.text "An Elm Notebook is made up of cells which contain both text and Elm code. "
                , E.el [ Font.italic, Font.color (E.rgb 0.65 0.65 1.0) ] (E.text "Click on the \"Sign in as Guest,\" button get started and see examples. (See link above center in blue.)")
                ]
            , E.row [ E.height (E.px 8) ] []
            , E.paragraph [ E.spacing 8, Font.italic ]
                [ E.text "To create and save notebooks: (1) Sign up.  (2) To edit a cell, click on it.  (3) To run the code in a cell, type ctrl-Enter or click on \"Run\"."
                ]
            , E.row [ E.height (E.px 8) ] []
            , E.paragraph [ E.spacing 8 ]
                [ E.text "The engine that runs the app is @minibill's elm-interpreter."
                , E.text " At this stage, the app is a proof-of-concept.  Some things won't work yet, and others will give wrong answers.  Stay tuned. We are working on it!"
                ]
            ]
        ]
