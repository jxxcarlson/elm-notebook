# Announcing Elm Notebook

The aim of [Elm Notebook](https://elm-notebook.lamdera.app) is to provide something akin to  Jupyter Notebooks, but for Elm: an app with cells in which you can put both text and code, and where code in a cell can be executed, producing output of various kinds — text, image, chart, animation, etc. I've thought of it mostly as a teaching
tool, but such an app could also be good for code demonstrations, experimentation,
and just playing around.

I'd like Elm Notebook to be something both fun and useful, and so invite suggestions, bug reports, and collaboration.  You can reach me on the Elm Slack where I am jxxcarlson.  The project is open source (of course!) with code at
[github.com/jxxcarlson/elm-notebook](https://github.com/jxxcarlson/elm-notebook).



## A Work-In-Progress

The project is very much a work-in-progress and I'd like to keep this experimental status in mind for a good while so that the project can adopt good ideas without
undue friction.

Elm Notebook is based on [elm-interpreter](https://github.com/miniBill/elm-interpreter) by @minibill (Leonardo Taglialegne).

You edit a cell by clicking on it, and you execute the code in it with control-RETURN, at which point the code is passed to elm-interpreter, with the result of the computation displayed below the cell:

![Cell](image/cell.png)