# Rendering Pipeline

Let's describe the process of rendering a notebook cell.  

## Cells and Notebooks

A notebook is a list of cells plus some metadata such as
the title and the author.  A cell is a record, as
defined below:


```elm
type alias Cell =
    { index : Int
    , text : List String
    , bindings : List String
    , expression : String
    , value : CellValue
    , cellState : CellState
    , locked : Bool
    }
```

- index: the position of a cell in its host notebook
- text: the source text
- bindings: the definitions made in the current and previous cells
- expression: the expression to be evaluated
- value: the result of evaluation (see `CellValue` below)
- cellState: tells whether we are looking at or editing
the cell (see `CellState` below)
- locked: If a cell is locked, it will not respond to clicks;
clicks are normally used to toggle between the
editing and view states.



```elm
type CellValue
    = CVNone
    | CVString String
    | CVVisual VisualType (List String)

type VisualType
    = VTChart
    | VTPlot2D
    | VTSvg
    | VTImage
    
type CellState
    = CSEdit
    | CSView    
```

### Example

Consider now a notebook with these cells: 
setup:

```elm
Cell 0: 
> a = 1
> b = 2

Cell 1:
> a + b

```

Cell 1 start out like this:

```elm
type alias Cell =
    { index = 1
    , text = "> a + b"
    , bindings = [ ]
    , expression ""
    , value = CVNone
    , cellState = CSView
    , locked = False
    }
```

When it is evaluated, it looks like this:

```elm
type alias Cell =
    { index = 1
    , text = "> a + b"
    , bindings = [ "a = 1", "b = 2" ]
    , expression "a + b"
    , value = CVString "3
    , cellState = CSView
    , locked = False
    }
```

In this case, all the bindings come from previous
cells.  It can happen that the current cell also 
contributes to the bindings.  For example, consider

```elm
Cell 1
> c = 3
> a + b + c
```

This cell begins life as

```elm
type alias Cell =
    { index = 1
    , text = "c = 3\n> a + b + c"
    , bindings = [ ]
    , expression ""
    , value = CVNone
    , cellState = CSView
    , locked = False
    }
```

After evaluation, it reads

```elm
type alias Cell =
    { index = 1
    , text = "c = 3\n> a + b + c"
    , bindings = ["a = 1", "b = 2", "c = 3"]
    , expression "a + b + c"
    , value = CVString "6"
    , cellState = CSView
    , locked = False
    }
```

## Evaluation

Evaluation is a multi-step process that results in the 
production of the `value` field of a cell.  The
key technology here is Leonardo Taglialegne's
[elm-interpreter](https://github.com/miniBill/elm-interpreter).


The first step is to gather the
bindings of cell N from definitions made in 
cells i for i <= N.  Bindings are recorded as a list of
strings. In addition, the current expression is extracted.
Next, a let expression is proposed, e.g., 

```elm
let
     a = 1
     b = 2
     c = 3
in 
     a + b + c
```                                                                             

The general form is

```elm
let
  definition 1
  definition 2
  ...
  definition N
in
  expression
```

This expression is evaluated using the function

```elm
-- LiveBook.Eval
evaluateString : String -> String
```

which calls on functions from `elm-interpreter` in 
the `Eval` and `Value` modules:
```elm
evaluateString : String -> String
evaluateString input =
    case Eval.eval input |> Result.map Value.toString of
        Ok output ->
            output

        Err err ->
            ... return a string describing the error ...
```

The process just described is managed by the function below.
It sets the `value` field of a cell to `CVString str` 
where `str` is the result of evaluation — either the
string representation of the resulting Value (produced
by `evaluateString`), or 
a string representation of the error.

```elm
-- LiveBook.Eval
evaluateWithCumulativeBindings : Dict String String -> List Cell -> Cell -> Cell
evaluateWithCumulativeBindings kvDict cells cell = ...
```

Here `cell` is the current cell and `cells`is the list of 
all cells in the notebook.


## Non-Standard Evaluation

The process just described the default evaluation process.
It always produces values of the form `CVString str`.  The 
other possibility is `CVVisual VisualType (List String)` where 
`VisualType` is one of  `VTChart`, `VTPlot2D`, `VTSvg`, or `VTImage`,
and were `(List String)` provides the data needed to render
a chart, produce a 2D plot, an SVG image, or a graphic image.


