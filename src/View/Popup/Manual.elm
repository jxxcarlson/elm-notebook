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

A cell consists of Elm declarations, Elm expressions, and comments.  Here is an example:

```
  # This is some Elm code:

  > a = 2   # declaration
  > b = 5   # declaration
  > a * b   # expression
```

Comments are prefixed by `#` and code is prefixed by `>`.

The result of evaluating the code is shown below the code. A cell
may contain more than one expression, but each must begin with "`>`".
Click in a cell to edit it, then type ctrl-Enter to evaluate it.

For examples, take a look at
the public notebook [Welcome to Elm Notebook](https://elm-notebook.lamdera.app/p/jxxcarlson-welcome-to-elm-notebooks).
You can follow this link as a guest, or sign in, click on the **Public** button (upper right), and
then select *Welcome to Elm Notebook* from the list of public notebooks.


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

Data can
be imported from a `.csv` file and stored in a variable using the command `readinto`.
The command `readinto foo` will store the file contents in the variable `foo`.
To visualize imported data, use the `chart` command, e.g.,
`chart timeseries columns:1 foo` to display a time series of the data in column 1
of `foo`, or `chart scatter columns:3,5 foo` for a scatter plot of the
data in columns 3 and 5..  See the public notebook
**Data, Charts, and Images** for examples.


## The Dataset Library

Elm notebooks has a library of sample data sets. One of these
is `jxxcarlson.stocks`.
To import it,  say `import jxxcarlson.stocks`.  The contents of
this dataset will be stored in the variable `jxxcarlson.stocks`
of the current notebook.  To store it in the variable `foo`, say
`import jxxcarlson.stocks as foo` instead. Again, see
the public notebook **Data, Charts, and Images** for examples.

To create a data set from a file on your computer, click
on the button 'New Data Set' in the footer.
In the reverse direction, you can export a data set to a file  with the
 command `export jxxcarlson.stocks`.

"""
