module Core.Tuple exposing (first, functions, mapBoth, mapFirst, mapSecond, pair, second)

{-| 
@docs functions, pair, first, second, mapFirst, mapSecond, mapBoth
-}


import Elm.Syntax.Expression
import Elm.Syntax.Pattern
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "pair", pair )
        , ( "first", first )
        , ( "second", second )
        , ( "mapFirst", mapFirst )
        , ( "mapSecond", mapSecond )
        , ( "mapBoth", mapBoth )
        ]


pair : Elm.Syntax.Expression.FunctionImplementation
pair =
    { name = Syntax.fakeNode "Tuple.pair"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "a")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "b")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.TupledExpression
                [ Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "a")
                , Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "b")
                ]
            )
    }


first : Elm.Syntax.Expression.FunctionImplementation
first =
    { name = Syntax.fakeNode "Tuple.first"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.TuplePattern
                [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
                , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                ]
            )
        ]
    , expression =
        Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "x")
    }


second : Elm.Syntax.Expression.FunctionImplementation
second =
    { name = Syntax.fakeNode "Tuple.second"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.TuplePattern
                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "y")
                ]
            )
        ]
    , expression =
        Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "y")
    }


mapFirst : Elm.Syntax.Expression.FunctionImplementation
mapFirst =
    { name = Syntax.fakeNode "Tuple.mapFirst"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.TuplePattern
                [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
                , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "y")
                ]
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.TupledExpression
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "func")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "x")
                        ]
                    )
                , Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "y")
                ]
            )
    }


mapSecond : Elm.Syntax.Expression.FunctionImplementation
mapSecond =
    { name = Syntax.fakeNode "Tuple.mapSecond"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.TuplePattern
                [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
                , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "y")
                ]
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.TupledExpression
                [ Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "x")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "func")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "y")
                        ]
                    )
                ]
            )
    }


mapBoth : Elm.Syntax.Expression.FunctionImplementation
mapBoth =
    { name = Syntax.fakeNode "Tuple.mapBoth"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "funcA")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "funcB")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.TuplePattern
                [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
                , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "y")
                ]
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.TupledExpression
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "funcA")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "x")
                        ]
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "funcB")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "y")
                        ]
                    )
                ]
            )
    }