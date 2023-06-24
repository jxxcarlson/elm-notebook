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

Click on the **Manual** button to show or hide the manual.

## Cells

Click in a cell to edit it, then type ctrl-Enter to evaluate it.

## Public versus private notebooks

Notebooks are either public or private.  Public notebooks are visible to all users.
To change the status of a notebook, click on the 'Private' button in the notebook footer.

You can work with a pubic notebook that does not belong to you: edit and evaluate
cells, delete cells and make new ones. However, these changes will not be saved.
If you want to save changes to a public notebook, clone it (see below)  Cloning a notebook
creates a new notebook that belongs to you.



Note the two buttons **Mine** and **Public** at the top of the notebook list (right-hand column).
Click on the **Mine**
botton to show your documents. Click on **Public** to show public documents that do not
belong to you.


## Cloning a notebook

Public documents can be cloned by clicking on the 'Clone' button in the footer.
A notebook that has been cloned can be updated by clicking on the 'Update' button in the footer.
Updating a notebook will overwrite any changes you have made to it.



"""
