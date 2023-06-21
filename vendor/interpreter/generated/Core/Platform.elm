module Core.Platform exposing (functions, sendToApp, sendToSelf, worker)

{-| 
@docs functions, worker, sendToApp, sendToSelf
-}


import Elm.Syntax.Expression
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "worker", worker )
        , ( "sendToApp", sendToApp )
        , ( "sendToSelf", sendToSelf )
        ]


worker : Elm.Syntax.Expression.FunctionImplementation
worker =
    { name = Syntax.fakeNode "Platform.worker"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "worker"
            )
    }


sendToApp : Elm.Syntax.Expression.FunctionImplementation
sendToApp =
    { name = Syntax.fakeNode "Platform.sendToApp"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "sendToApp"
            )
    }


sendToSelf : Elm.Syntax.Expression.FunctionImplementation
sendToSelf =
    { name = Syntax.fakeNode "Platform.sendToSelf"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "sendToSelf"
            )
    }