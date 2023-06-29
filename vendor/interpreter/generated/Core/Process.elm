module Core.Process exposing (functions, kill, sleep, spawn)

{-| 
@docs functions, spawn, sleep, kill
-}


import Elm.Syntax.Expression
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "spawn", spawn ), ( "sleep", sleep ), ( "kill", kill ) ]


spawn : Elm.Syntax.Expression.FunctionImplementation
spawn =
    { name = Syntax.fakeNode "Process.spawn"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Scheduler" ]
                "spawn"
            )
    }


sleep : Elm.Syntax.Expression.FunctionImplementation
sleep =
    { name = Syntax.fakeNode "Process.sleep"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Process" ]
                "sleep"
            )
    }


kill : Elm.Syntax.Expression.FunctionImplementation
kill =
    { name = Syntax.fakeNode "Process.kill"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Scheduler" ]
                "kill"
            )
    }