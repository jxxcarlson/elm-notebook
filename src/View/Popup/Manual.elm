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
    Element.column [ Element.spacing 8, Element.width (Element.px 400), Element.paddingEach { top = 12, bottom = 48, left = 0, right = 0 } ]
        [ Element.image [ Element.centerX, Element.width (Element.px 350) ] { src = source, description = description }
        , Element.el [ Element.centerX, Font.size 13 ] (Element.text caption)
        ]



-- image "https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/30f08d58-dbce-42a0-97a6-512735707700/public" "bird" "Mascot"
--<img src="https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/30f08d58-dbce-42a0-97a6-512735707700/public"
--description="bird"
--caption="Mascot">
--</img>


content =
    """


## This manual


Click on the **Manual** button to show or hide the manual.

## Cells

Here is a typical cell:

```
  # A cell consists of text and Elm code

  > a = 2   # definition
  > b = 5   # definition
  > a * b   # expression
```
Text is prefixed by `#` and code is prefixed by `>`.  Code consists of (i) a sequence of
definitions followed by (ii) an expression.  Either of these elements may be omitted.

The result of evaluating the code is shown below the code.

Click in a cell to edit it, then type ctrl-Enter to evaluate it.

For examples and a discussion of cell format, take a look at
the public notebook **Welcome to Elm Notebook.** For this you
need to be signed in.  Then click on the **Public** button at the top
of the notebook list, right-hand column.

## Public versus private notebooks

Notebooks are either public or private.  Public notebooks are visible to all users.
To change the status of a notebook, click on the **Private** button in the notebook footer.

You can work with a pubic notebook that does not belong to you: edit and evaluate
cells, delete cells and make new ones. However, these changes will not be saved.
If you want to save changes to a public notebook, clone it (see below)  Cloning a notebook
creates a copy of the notebook that belongs to you.



Note the two buttons **Mine** and **Public** at the top of the notebook list (right-hand column).
Click on the **Mine**
button to show your documents. Click on **Public** to show public documents that do not
belong to you.


## Cloning a notebook

Public documents can be cloned by clicking on the **Clone** button in the footer.

You can also update a notebook that has been cloned: click on the **Update** button in the footer.
Updating a notebook brings in new material from the original source.
However this operation will overwrite any changes you have made to the clone.

## Working with data

We are building various facilities for working with data.  Data can
be imported from a `.csv` file using a command like `readinto foo`.
When you execute this command, you will be prompted to select a file;
its contents will be stored in the variable `foo`
To visualize data, use the `chart` command.  See the public notebook
**Data, Charts, and Images** for examples.

Elm notebooks has a library of sample data sets. One of these
 is `jxxcarlson.stocks`.  You can export it
to a file on your computer with the command `export jxxcarlson.stocks`.
To import it directly into a notebook, just say `import jxxcarlson.stocks`.

"""
