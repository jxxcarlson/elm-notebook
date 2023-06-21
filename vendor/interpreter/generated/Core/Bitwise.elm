module Core.Bitwise exposing (and, complement, functions, or, shiftLeftBy, shiftRightBy, shiftRightZfBy, xor)

{-| 
@docs functions, and, or, xor, complement, shiftLeftBy, shiftRightBy, shiftRightZfBy
-}


import Elm.Syntax.Expression
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "and", and )
        , ( "or", or )
        , ( "xor", xor )
        , ( "complement", complement )
        , ( "shiftLeftBy", shiftLeftBy )
        , ( "shiftRightBy", shiftRightBy )
        , ( "shiftRightZfBy", shiftRightZfBy )
        ]


and : Elm.Syntax.Expression.FunctionImplementation
and =
    { name = Syntax.fakeNode "Bitwise.and"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "and"
            )
    }


or : Elm.Syntax.Expression.FunctionImplementation
or =
    { name = Syntax.fakeNode "Bitwise.or"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "or"
            )
    }


xor : Elm.Syntax.Expression.FunctionImplementation
xor =
    { name = Syntax.fakeNode "Bitwise.xor"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "xor"
            )
    }


complement : Elm.Syntax.Expression.FunctionImplementation
complement =
    { name = Syntax.fakeNode "Bitwise.complement"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "complement"
            )
    }


shiftLeftBy : Elm.Syntax.Expression.FunctionImplementation
shiftLeftBy =
    { name = Syntax.fakeNode "Bitwise.shiftLeftBy"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "shiftLeftBy"
            )
    }


shiftRightBy : Elm.Syntax.Expression.FunctionImplementation
shiftRightBy =
    { name = Syntax.fakeNode "Bitwise.shiftRightBy"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "shiftRightBy"
            )
    }


shiftRightZfBy : Elm.Syntax.Expression.FunctionImplementation
shiftRightZfBy =
    { name = Syntax.fakeNode "Bitwise.shiftRightZfBy"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "shiftRightZfBy"
            )
    }