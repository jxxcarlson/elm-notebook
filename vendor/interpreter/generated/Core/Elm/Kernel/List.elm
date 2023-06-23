module Core.Elm.Kernel.List exposing (functions, map2, map3, map4, map5, mergeWith, sortBy, sortWith, split)

{-| 
@docs functions, map2, map3, map4, map5, sortBy, sortWith, split, mergeWith
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
        , ( "sortBy", sortBy )
        , ( "sortWith", sortWith )
        , ( "split", split )
        , ( "mergeWith", mergeWith )
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


sortBy : Elm.Syntax.Expression.FunctionImplementation
sortBy =
    { name = Syntax.fakeNode "Elm.Kernel.List.sortBy"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "sortWith")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "l")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "r")
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "compare"
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
                                                                    "l"
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
                                                                    []
                                                                    "f"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "r"
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                ]
            )
    }


sortWith : Elm.Syntax.Expression.FunctionImplementation
sortWith =
    { name = Syntax.fakeNode "Elm.Kernel.List.sortWith"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                , cases =
                    [ ( Syntax.fakeNode (Elm.Syntax.Pattern.ListPattern [])
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.ListPattern
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                      )
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.LetDestructuring
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Pattern.TuplePattern
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "left"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "right"
                                                        )
                                                    ]
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Application
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "split"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "xs"
                                                        )
                                                    ]
                                                )
                                            )
                                        )
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "mergeWith"
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
                                                                    "sortWith"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "f"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "left"
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
                                                                    []
                                                                    "sortWith"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "f"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "right"
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                }
                            )
                      )
                    ]
                }
            )
    }


split : Elm.Syntax.Expression.FunctionImplementation
split =
    { name = Syntax.fakeNode "Elm.Kernel.List.split"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs") ]
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
                                    { name = Syntax.fakeNode "goLeft"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "l")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "lacc"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "racc"
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "l"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.TupledExpression
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lacc"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "racc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lh"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lt"
                                                                    )
                                                                )
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "goRight"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lt"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                "::"
                                                                                Elm.Syntax.Infix.Left
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "lh"
                                                                                    )
                                                                                )
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "lacc"
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "racc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    ]
                                                }
                                            )
                                    }
                            }
                        )
                    , Syntax.fakeNode
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "goRight"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "l")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "lacc"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "racc"
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "l"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.TupledExpression
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lacc"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "racc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lh"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lt"
                                                                    )
                                                                )
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "goLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lt"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lacc"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                "::"
                                                                                Elm.Syntax.Infix.Left
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "lh"
                                                                                    )
                                                                                )
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "racc"
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
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "goLeft"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ListExpr [])
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


mergeWith : Elm.Syntax.Expression.FunctionImplementation
mergeWith =
    { name = Syntax.fakeNode "Elm.Kernel.List.mergeWith"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ls")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rs")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "ls")
                , cases =
                    [ ( Syntax.fakeNode (Elm.Syntax.Pattern.ListPattern [])
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "rs")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.UnConsPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "lh")
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "lt")
                                )
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "rs"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.ListPattern [])
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "ls"
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.UnConsPattern
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rh"
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rt"
                                                    )
                                                )
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.Application
                                                            [ Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "f"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "lh"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "rh"
                                                                )
                                                            ]
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "LT"
                                                                }
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lh"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "mergeWith"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "f"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "lt"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "rs"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "GT"
                                                                }
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rh"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "mergeWith"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "f"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "ls"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "rt"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "EQ"
                                                                }
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "::"
                                                                        Elm.Syntax.Infix.Left
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "lh"
                                                                            )
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "rh"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "mergeWith"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "f"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "lt"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "rt"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
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