module Core.Elm.Kernel.List exposing (functions, map2, map3, map4, map5)

{-| 
@docs functions, map2, map3, map4, map5
-}


import Elm.Syntax.Expression
import Elm.Syntax.Infix
import Elm.Syntax.Pattern
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "map2", map2 )
        , ( "map3", map3 )
        , ( "map4", map4 )
        , ( "map5", map5 )
        ]


map2 : Elm.Syntax.Expression.FunctionImplementation
map2 =
    { name = Syntax.fakeNode "Elm.Kernel.List.map2"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xas")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xbs")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ Syntax.fakeNode
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "go"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "ao")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "bo")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "ao"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "acc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "ah"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "at"
                                                                    )
                                                                )
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "bo"
                                                                        )
                                                                , cases =
                                                                    [ ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                []
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "List"
                                                                                        ]
                                                                                        "reverse"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "acc"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bh"
                                                                                    )
                                                                                )
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bt"
                                                                                    )
                                                                                )
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "go"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "at"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "bt"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                "::"
                                                                                                Elm.Syntax.Infix.Left
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
                                                                                                                "ah"
                                                                                                            )
                                                                                                        , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "bh"
                                                                                                            )
                                                                                                        ]
                                                                                                    )
                                                                                                )
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "acc"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    ]
                                                                }
                                                            )
                                                      )
                                                    ]
                                                }
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "go")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xas")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xbs")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


map3 : Elm.Syntax.Expression.FunctionImplementation
map3 =
    { name = Syntax.fakeNode "Elm.Kernel.List.map3"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xas")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xbs")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xcs")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ Syntax.fakeNode
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "go"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "ao")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "bo")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "co")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "ao"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "acc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "ah"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "at"
                                                                    )
                                                                )
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "bo"
                                                                        )
                                                                , cases =
                                                                    [ ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                []
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "List"
                                                                                        ]
                                                                                        "reverse"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "acc"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bh"
                                                                                    )
                                                                                )
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bt"
                                                                                    )
                                                                                )
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                { expression =
                                                                                    Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                            []
                                                                                            "co"
                                                                                        )
                                                                                , cases =
                                                                                    [ ( Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                []
                                                                                            )
                                                                                      , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        [ "List"
                                                                                                        ]
                                                                                                        "reverse"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "acc"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      )
                                                                                    , ( Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ch"
                                                                                                    )
                                                                                                )
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ct"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                      , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "go"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "at"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "bt"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "ct"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                "::"
                                                                                                                Elm.Syntax.Infix.Left
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
                                                                                                                                "ah"
                                                                                                                            )
                                                                                                                        , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                []
                                                                                                                                "bh"
                                                                                                                            )
                                                                                                                        , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                []
                                                                                                                                "ch"
                                                                                                                            )
                                                                                                                        ]
                                                                                                                    )
                                                                                                                )
                                                                                                                (Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "acc"
                                                                                                                    )
                                                                                                                )
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      )
                                                                                    ]
                                                                                }
                                                                            )
                                                                      )
                                                                    ]
                                                                }
                                                            )
                                                      )
                                                    ]
                                                }
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "go")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xas")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xbs")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xcs")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


map4 : Elm.Syntax.Expression.FunctionImplementation
map4 =
    { name = Syntax.fakeNode "Elm.Kernel.List.map4"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xas")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xbs")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xcs")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xds")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ Syntax.fakeNode
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "go"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "ao")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "bo")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "co")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "do")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "ao"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "acc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "ah"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "at"
                                                                    )
                                                                )
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "bo"
                                                                        )
                                                                , cases =
                                                                    [ ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                []
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "List"
                                                                                        ]
                                                                                        "reverse"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "acc"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bh"
                                                                                    )
                                                                                )
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bt"
                                                                                    )
                                                                                )
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                { expression =
                                                                                    Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                            []
                                                                                            "co"
                                                                                        )
                                                                                , cases =
                                                                                    [ ( Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                []
                                                                                            )
                                                                                      , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        [ "List"
                                                                                                        ]
                                                                                                        "reverse"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "acc"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      )
                                                                                    , ( Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ch"
                                                                                                    )
                                                                                                )
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ct"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                      , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                                { expression =
                                                                                                    Syntax.fakeNode
                                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                                            []
                                                                                                            "do"
                                                                                                        )
                                                                                                , cases =
                                                                                                    [ ( Syntax.fakeNode
                                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                                []
                                                                                                            )
                                                                                                      , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        [ "List"
                                                                                                                        ]
                                                                                                                        "reverse"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "acc"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                      )
                                                                                                    , ( Syntax.fakeNode
                                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                                (Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                        "dh"
                                                                                                                    )
                                                                                                                )
                                                                                                                (Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                        "dt"
                                                                                                                    )
                                                                                                                )
                                                                                                            )
                                                                                                      , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "go"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "at"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "bt"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "ct"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "dt"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                        (Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                "::"
                                                                                                                                Elm.Syntax.Infix.Left
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
                                                                                                                                                "ah"
                                                                                                                                            )
                                                                                                                                        , Syntax.fakeNode
                                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                []
                                                                                                                                                "bh"
                                                                                                                                            )
                                                                                                                                        , Syntax.fakeNode
                                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                []
                                                                                                                                                "ch"
                                                                                                                                            )
                                                                                                                                        , Syntax.fakeNode
                                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                []
                                                                                                                                                "dh"
                                                                                                                                            )
                                                                                                                                        ]
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "acc"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                      )
                                                                                                    ]
                                                                                                }
                                                                                            )
                                                                                      )
                                                                                    ]
                                                                                }
                                                                            )
                                                                      )
                                                                    ]
                                                                }
                                                            )
                                                      )
                                                    ]
                                                }
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "go")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xas")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xbs")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xcs")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xds")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


map5 : Elm.Syntax.Expression.FunctionImplementation
map5 =
    { name = Syntax.fakeNode "Elm.Kernel.List.map5"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xas")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xbs")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xcs")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xds")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xes")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ Syntax.fakeNode
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "go"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "ao")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "bo")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "co")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "do")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "eo")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "ao"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "acc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "ah"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "at"
                                                                    )
                                                                )
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "bo"
                                                                        )
                                                                , cases =
                                                                    [ ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                []
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "List"
                                                                                        ]
                                                                                        "reverse"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "acc"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bh"
                                                                                    )
                                                                                )
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bt"
                                                                                    )
                                                                                )
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                { expression =
                                                                                    Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                            []
                                                                                            "co"
                                                                                        )
                                                                                , cases =
                                                                                    [ ( Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                []
                                                                                            )
                                                                                      , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        [ "List"
                                                                                                        ]
                                                                                                        "reverse"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "acc"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      )
                                                                                    , ( Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ch"
                                                                                                    )
                                                                                                )
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ct"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                      , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                                { expression =
                                                                                                    Syntax.fakeNode
                                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                                            []
                                                                                                            "do"
                                                                                                        )
                                                                                                , cases =
                                                                                                    [ ( Syntax.fakeNode
                                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                                []
                                                                                                            )
                                                                                                      , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        [ "List"
                                                                                                                        ]
                                                                                                                        "reverse"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "acc"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                      )
                                                                                                    , ( Syntax.fakeNode
                                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                                (Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                        "dh"
                                                                                                                    )
                                                                                                                )
                                                                                                                (Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                        "dt"
                                                                                                                    )
                                                                                                                )
                                                                                                            )
                                                                                                      , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                                                { expression =
                                                                                                                    Syntax.fakeNode
                                                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                            []
                                                                                                                            "eo"
                                                                                                                        )
                                                                                                                , cases =
                                                                                                                    [ ( Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                                                []
                                                                                                                            )
                                                                                                                      , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                                [ Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        [ "List"
                                                                                                                                        ]
                                                                                                                                        "reverse"
                                                                                                                                    )
                                                                                                                                , Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "acc"
                                                                                                                                    )
                                                                                                                                ]
                                                                                                                            )
                                                                                                                      )
                                                                                                                    , ( Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                                        "eh"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                                        "et"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                      , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                                [ Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "go"
                                                                                                                                    )
                                                                                                                                , Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "at"
                                                                                                                                    )
                                                                                                                                , Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "bt"
                                                                                                                                    )
                                                                                                                                , Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "ct"
                                                                                                                                    )
                                                                                                                                , Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "dt"
                                                                                                                                    )
                                                                                                                                , Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "et"
                                                                                                                                    )
                                                                                                                                , Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                                        (Syntax.fakeNode
                                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                                "::"
                                                                                                                                                Elm.Syntax.Infix.Left
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
                                                                                                                                                                "ah"
                                                                                                                                                            )
                                                                                                                                                        , Syntax.fakeNode
                                                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                                []
                                                                                                                                                                "bh"
                                                                                                                                                            )
                                                                                                                                                        , Syntax.fakeNode
                                                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                                []
                                                                                                                                                                "ch"
                                                                                                                                                            )
                                                                                                                                                        , Syntax.fakeNode
                                                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                                []
                                                                                                                                                                "dh"
                                                                                                                                                            )
                                                                                                                                                        , Syntax.fakeNode
                                                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                                []
                                                                                                                                                                "eh"
                                                                                                                                                            )
                                                                                                                                                        ]
                                                                                                                                                    )
                                                                                                                                                )
                                                                                                                                                (Syntax.fakeNode
                                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                        []
                                                                                                                                                        "acc"
                                                                                                                                                    )
                                                                                                                                                )
                                                                                                                                            )
                                                                                                                                        )
                                                                                                                                    )
                                                                                                                                ]
                                                                                                                            )
                                                                                                                      )
                                                                                                                    ]
                                                                                                                }
                                                                                                            )
                                                                                                      )
                                                                                                    ]
                                                                                                }
                                                                                            )
                                                                                      )
                                                                                    ]
                                                                                }
                                                                            )
                                                                      )
                                                                    ]
                                                                }
                                                            )
                                                      )
                                                    ]
                                                }
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "go")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xas")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xbs")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xcs")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xds")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xes")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }