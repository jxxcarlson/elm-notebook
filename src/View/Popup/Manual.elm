module View.Popup.Manual exposing (view)

import Element
import Element.Background as Background
import Element.Font as Font
import Types exposing (PopupState(..))
import View.Geometry
import View.MarkdownThemed as MarkdownThemed
import View.Utility


view model theme =
    View.Utility.showIf (model.popupState == ManualPopup) <|
        Element.column
            [ Background.color theme.background
            , Element.width (Element.px <| View.Geometry.appWidth model // 2)
            , Element.height (Element.px <| View.Geometry.bodyHeight model)
            , Element.moveUp (toFloat <| View.Geometry.bodyHeight model)
            , Element.padding 36
            , Element.alignRight
            ]
            [ MarkdownThemed.renderFull (scale 0.42 (View.Geometry.appWidth model)) (View.Geometry.bodyHeight model) content
            ]


scale : Float -> Int -> Int
scale factor x =
    round <| factor * toFloat x


image source description caption =
    Element.newTabLink [] { url = source, label = image_ source description caption }


image_ source description caption =
    Element.column [ Element.spacing 8, Element.width (Element.px 400) ]
        [ Element.image [ Element.centerX, Element.width (Element.px 350) ] { src = source, description = description }
        , Element.el [ Element.centerX, Font.size 13 ] (Element.text caption)
        ]


content =
    """

## This manual

Click on the 'Manual' button again to hide the manual.

## Cells

Click in a cell to edit it, then type ctrl-Enter to evaluate it.

## Public versus private notebooks

Notebooks are either public or private.  Public notebooks are visible to all users.
To change the status of a notebook, click on the 'Private' button in the notebook footer.

## Identifiers

All notebooks have a short identifier.  The  short identifier of a notebook is shown in the footer.
Here is an example: 'jxxcarlson.exercises-a'. Short identifiers always
begin with the author's username.  The rest of the identifier comes from the title.
If you change the title of a notebook, the identifier
will change accordingly.

## Cloning a notebook

You can clone a public notebook by entering its short identifier in the 'Notebook identifier' field, then
clicking on the 'Clone' button in the notebook header.

"""
