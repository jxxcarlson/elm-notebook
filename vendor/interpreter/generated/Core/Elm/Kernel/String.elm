module Core.Elm.Kernel.String exposing (all, any, foldl, foldr, functions, map)

{-| 
@docs functions, any, all, map, foldl, foldr
-}


import Elm.Syntax.Expression
import Elm.Syntax.Pattern
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "any", any )
        , ( "all", all )
        , ( "map", map )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        ]


any : Elm.Syntax.Expression.FunctionImplementation
any =
    { name = Syntax.fakeNode "Elm.Kernel.String.any"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "s")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "any")
                , Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "f")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "String" ]
                                        "toList"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "s"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


all : Elm.Syntax.Expression.FunctionImplementation
all =
    { name = Syntax.fakeNode "Elm.Kernel.String.all"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "s")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "all")
                , Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "f")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "String" ]
                                        "toList"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "s"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = Syntax.fakeNode "Elm.Kernel.String.map"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "s")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue
                        [ "String" ]
                        "fromList"
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "List" ]
                                        "map"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "f"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "String" ]
                                                        "toList"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "s"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = Syntax.fakeNode "Elm.Kernel.String.foldl"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "i")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "s")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    [ "String" ]
                                    "uncons"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "s")
                            ]
                        )
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "i")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "c")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "t")
                                        ]
                                    )
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "foldl"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "f"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "f"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "c"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "i"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "t"
                                    )
                                ]
                            )
                      )
                    ]
                }
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = Syntax.fakeNode "Elm.Kernel.String.foldr"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "i")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "s")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    [ "String" ]
                                    "uncons"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "String" ]
                                                    "right"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.Integer 1
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "s"
                                                )
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "i")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "c")
                                        , Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        ]
                                    )
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "foldr"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "f"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "f"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "c"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "i"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "String" ]
                                                        "dropRight"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Integer
                                                        1
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "s"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      )
                    ]
                }
            )
    }