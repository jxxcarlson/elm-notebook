module Core.Platform.Cmd exposing (batch, functions, map, none)

{-| 
@docs functions, none, batch, map
-}


import Elm.Syntax.Expression
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList [ ( "none", none ), ( "batch", batch ), ( "map", map ) ]


none : Elm.Syntax.Expression.FunctionImplementation
none =
    { name = Syntax.fakeNode "Platform.Cmd.none"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "batch")
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


batch : Elm.Syntax.Expression.FunctionImplementation
batch =
    { name = Syntax.fakeNode "Platform.Cmd.batch"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "batch"
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = Syntax.fakeNode "Platform.Cmd.map"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "map"
            )
    }