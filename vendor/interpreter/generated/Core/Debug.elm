module Core.Debug exposing (functions, log, toString, todo)

{-| 
@docs functions, toString, log, todo
-}


import Elm.Syntax.Expression
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "toString", toString ), ( "log", log ), ( "todo", todo ) ]


toString : Elm.Syntax.Expression.FunctionImplementation
toString =
    { name = Syntax.fakeNode "Debug.toString"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Debug" ]
                "toString"
            )
    }


log : Elm.Syntax.Expression.FunctionImplementation
log =
    { name = Syntax.fakeNode "Debug.log"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Debug" ]
                "log"
            )
    }


todo : Elm.Syntax.Expression.FunctionImplementation
todo =
    { name = Syntax.fakeNode "Debug.todo"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Debug" ]
                "todo"
            )
    }