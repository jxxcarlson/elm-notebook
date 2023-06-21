module Core.Maybe exposing (andThen, destruct, functions, isJust, map, map2, map3, map4, map5, withDefault)

{-| 
@docs functions, withDefault, map, map2, map3, map4, map5, andThen, isJust, destruct
-}


import Elm.Syntax.Expression
import Elm.Syntax.Pattern
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "withDefault", withDefault )
        , ( "map", map )
        , ( "map2", map2 )
        , ( "map3", map3 )
        , ( "map4", map4 )
        , ( "map5", map5 )
        , ( "andThen", andThen )
        , ( "isJust", isJust )
        , ( "destruct", destruct )
        ]


withDefault : Elm.Syntax.Expression.FunctionImplementation
withDefault =
    { name = Syntax.fakeNode "Maybe.withDefault"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "default")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "maybe")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "maybe")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "value")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "default")
                      )
                    ]
                }
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = Syntax.fakeNode "Maybe.map"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "maybe")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "maybe")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Just"
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
                                                        "value"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    ]
                }
            )
    }


map2 : Elm.Syntax.Expression.FunctionImplementation
map2 =
    { name = Syntax.fakeNode "Maybe.map2"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ma")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "mb")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "ma")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "mb"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Nothing"
                                                }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "Nothing"
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Just"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Just"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "func"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "a"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "b"
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
                      )
                    ]
                }
            )
    }


map3 : Elm.Syntax.Expression.FunctionImplementation
map3 =
    { name = Syntax.fakeNode "Maybe.map3"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ma")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "mb")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "mc")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "ma")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "mb"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Nothing"
                                                }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "Nothing"
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Just"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "mc"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "Nothing"
                                                                }
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "Nothing"
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Just"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "c"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Just"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "func"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "a"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "b"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "c"
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
                                      )
                                    ]
                                }
                            )
                      )
                    ]
                }
            )
    }


map4 : Elm.Syntax.Expression.FunctionImplementation
map4 =
    { name = Syntax.fakeNode "Maybe.map4"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ma")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "mb")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "mc")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "md")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "ma")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "mb"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Nothing"
                                                }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "Nothing"
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Just"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "mc"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "Nothing"
                                                                }
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "Nothing"
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Just"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "c"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "md"
                                                                        )
                                                                , cases =
                                                                    [ ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Nothing"
                                                                                }
                                                                                []
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "Nothing"
                                                                            )
                                                                      )
                                                                    , ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Just"
                                                                                }
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "d"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "Just"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "func"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "a"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "b"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "c"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "d"
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


map5 : Elm.Syntax.Expression.FunctionImplementation
map5 =
    { name = Syntax.fakeNode "Maybe.map5"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ma")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "mb")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "mc")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "md")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "me")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "ma")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "mb"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Nothing"
                                                }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "Nothing"
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Just"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "mc"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "Nothing"
                                                                }
                                                                []
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "Nothing"
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Just"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "c"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "md"
                                                                        )
                                                                , cases =
                                                                    [ ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Nothing"
                                                                                }
                                                                                []
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "Nothing"
                                                                            )
                                                                      )
                                                                    , ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Just"
                                                                                }
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "d"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                { expression =
                                                                                    Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                            []
                                                                                            "me"
                                                                                        )
                                                                                , cases =
                                                                                    [ ( Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                                { moduleName =
                                                                                                    []
                                                                                                , name =
                                                                                                    "Nothing"
                                                                                                }
                                                                                                []
                                                                                            )
                                                                                      , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "Nothing"
                                                                                            )
                                                                                      )
                                                                                    , ( Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                                { moduleName =
                                                                                                    []
                                                                                                , name =
                                                                                                    "Just"
                                                                                                }
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "e"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "Just"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "func"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "a"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "b"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "c"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "d"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "e"
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


andThen : Elm.Syntax.Expression.FunctionImplementation
andThen =
    { name = Syntax.fakeNode "Maybe.andThen"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "callback")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "maybeValue")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "maybeValue")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "callback"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "value"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    ]
                }
            )
    }


isJust : Elm.Syntax.Expression.FunctionImplementation
isJust =
    { name = Syntax.fakeNode "Maybe.isJust"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "maybe") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "maybe")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "True")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "False")
                      )
                    ]
                }
            )
    }


destruct : Elm.Syntax.Expression.FunctionImplementation
destruct =
    { name = Syntax.fakeNode "Maybe.destruct"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "default")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "maybe")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "maybe")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "func"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "a"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "default")
                      )
                    ]
                }
            )
    }