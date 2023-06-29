module Core.Result exposing (andThen, fromMaybe, functions, isOk, map, map2, map3, map4, map5, mapError, toMaybe, withDefault)

{-| 
@docs functions, withDefault, map, map2, map3, map4, map5, andThen, mapError, toMaybe, fromMaybe, isOk
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
        , ( "mapError", mapError )
        , ( "toMaybe", toMaybe )
        , ( "fromMaybe", fromMaybe )
        , ( "isOk", isOk )
        ]


withDefault : Elm.Syntax.Expression.FunctionImplementation
withDefault =
    { name = Syntax.fakeNode "Result.withDefault"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "def")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "result")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "result")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "a")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "def")
                      )
                    ]
                }
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = Syntax.fakeNode "Result.map"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ra")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "ra")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Ok"
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
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "e")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Err"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "e"
                                    )
                                ]
                            )
                      )
                    ]
                }
            )
    }


map2 : Elm.Syntax.Expression.FunctionImplementation
map2 =
    { name = Syntax.fakeNode "Result.map2"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ra")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rb")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "ra")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Err"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "x"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
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
                                            "rb"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Err"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Err"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "x"
                                                    )
                                                ]
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "Ok" }
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
                                                        "Ok"
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
    { name = Syntax.fakeNode "Result.map3"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ra")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rb")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rc")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "ra")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Err"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "x"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
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
                                            "rb"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Err"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Err"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "x"
                                                    )
                                                ]
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "Ok" }
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
                                                            "rc"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Err"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "x"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Err"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "x"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Ok"
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
                                                                        "Ok"
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
    { name = Syntax.fakeNode "Result.map4"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ra")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rb")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rc")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rd")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "ra")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Err"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "x"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
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
                                            "rb"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Err"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Err"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "x"
                                                    )
                                                ]
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "Ok" }
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
                                                            "rc"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Err"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "x"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Err"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "x"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Ok"
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
                                                                            "rd"
                                                                        )
                                                                , cases =
                                                                    [ ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Err"
                                                                                }
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "x"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "Err"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "x"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Ok"
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
                                                                                        "Ok"
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
    { name = Syntax.fakeNode "Result.map5"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ra")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rb")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rc")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rd")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "re")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "ra")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Err"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "x"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
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
                                            "rb"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Err"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Err"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "x"
                                                    )
                                                ]
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "Ok" }
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
                                                            "rc"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Err"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "x"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Err"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "x"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Ok"
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
                                                                            "rd"
                                                                        )
                                                                , cases =
                                                                    [ ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Err"
                                                                                }
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "x"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "Err"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "x"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Ok"
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
                                                                                            "re"
                                                                                        )
                                                                                , cases =
                                                                                    [ ( Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                                { moduleName =
                                                                                                    []
                                                                                                , name =
                                                                                                    "Err"
                                                                                                }
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "x"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "Err"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "x"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      )
                                                                                    , ( Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                                { moduleName =
                                                                                                    []
                                                                                                , name =
                                                                                                    "Ok"
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
                                                                                                        "Ok"
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
    { name = Syntax.fakeNode "Result.andThen"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "callback")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "result")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "result")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
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
                                { moduleName = [], name = "Err" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "msg")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Err"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "msg"
                                    )
                                ]
                            )
                      )
                    ]
                }
            )
    }


mapError : Elm.Syntax.Expression.FunctionImplementation
mapError =
    { name = Syntax.fakeNode "Result.mapError"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "result")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "result")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Ok"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "v"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "e")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Err"
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
    }


toMaybe : Elm.Syntax.Expression.FunctionImplementation
toMaybe =
    { name = Syntax.fakeNode "Result.toMaybe"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "result") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "result")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "v")
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
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "v"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    ]
                }
            )
    }


fromMaybe : Elm.Syntax.Expression.FunctionImplementation
fromMaybe =
    { name = Syntax.fakeNode "Result.fromMaybe"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "err")
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
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Ok"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "v"
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
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Err"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "err"
                                    )
                                ]
                            )
                      )
                    ]
                }
            )
    }


isOk : Elm.Syntax.Expression.FunctionImplementation
isOk =
    { name = Syntax.fakeNode "Result.isOk"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "result") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "result")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "True")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "False")
                      )
                    ]
                }
            )
    }