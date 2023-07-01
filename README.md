# elm-notebook

The intent of elm-notebook is an app like Jupyter notebook or Elixir
livebooks — that is, an app which presents a sequence of cells in which
you can write both code and text.  These cells, when evaluated, can
produce either text output, as in the Elm repl, or "visual type,"
e.g., an image, a chart, an animation, etc. This accomplished via
the following types for the value field of a cell (to be expanded).

```
type CellValue
    = CVNone
    | CVString String
    | CVVisual VisualType (List String)


type VisualType
    = VTChart
    | VTImage
```

In the `CVVisual` variant, the `List String` component is data that will
be processed to Html by, for example, a chart function.  We are using
[elm-charts-alpha](https://package.elm-lang.org/packages/terezka/charts/latest/).

The project began as [livebook.lamdera.app](https://livebook.lamdera.app), but
I realized that [elm-notebook.lamdera.app](https://elm-notebook.lamdera.app)
is more descriptive.  

The project is still in its infancy, and still in an exploratory phase, 
with first commit on June 20, 2023.  I welcome
comments and suggestions.
