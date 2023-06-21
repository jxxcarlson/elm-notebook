module Core.List exposing (all, any, append, concat, concatMap, cons, drop, filter, filterMap, foldl, foldr, foldrHelper, functions, head, indexedMap, intersperse, isEmpty, length, map, map2, map3, map4, map5, maximum, maybeCons, member, minimum, operators, partition, product, range, rangeHelp, repeat, repeatHelp, reverse, singleton, sort, sortBy, sortWith, sum, tail, take, takeFast, takeReverse, takeTailRec, unzip)

{-| 
@docs functions, operators, singleton, repeat, repeatHelp, range, rangeHelp, cons, map, indexedMap, foldl, foldr, foldrHelper, filter, filterMap, maybeCons, length, reverse, member, all, any, maximum, minimum, sum, product, append, concat, concatMap, intersperse, map2, map3, map4, map5, sort, sortBy, sortWith, isEmpty, head, tail, take, takeFast, takeTailRec, takeReverse, drop, partition, unzip
-}


import Elm.Syntax.Expression
import Elm.Syntax.Infix
import Elm.Syntax.Pattern
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "singleton", singleton )
        , ( "repeat", repeat )
        , ( "repeatHelp", repeatHelp )
        , ( "range", range )
        , ( "rangeHelp", rangeHelp )
        , ( "cons", cons )
        , ( "map", map )
        , ( "indexedMap", indexedMap )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        , ( "foldrHelper", foldrHelper )
        , ( "filter", filter )
        , ( "filterMap", filterMap )
        , ( "maybeCons", maybeCons )
        , ( "length", length )
        , ( "reverse", reverse )
        , ( "member", member )
        , ( "all", all )
        , ( "any", any )
        , ( "maximum", maximum )
        , ( "minimum", minimum )
        , ( "sum", sum )
        , ( "product", product )
        , ( "append", append )
        , ( "concat", concat )
        , ( "concatMap", concatMap )
        , ( "intersperse", intersperse )
        , ( "map2", map2 )
        , ( "map3", map3 )
        , ( "map4", map4 )
        , ( "map5", map5 )
        , ( "sort", sort )
        , ( "sortBy", sortBy )
        , ( "sortWith", sortWith )
        , ( "isEmpty", isEmpty )
        , ( "head", head )
        , ( "tail", tail )
        , ( "take", take )
        , ( "takeFast", takeFast )
        , ( "takeTailRec", takeTailRec )
        , ( "takeReverse", takeReverse )
        , ( "drop", drop )
        , ( "partition", partition )
        , ( "unzip", unzip )
        ]


operators : List ( String, Elm.Syntax.Pattern.QualifiedNameRef )
operators =
    [ ( "::", { moduleName = [ "List" ], name = "cons" } ) ]


singleton : Elm.Syntax.Expression.FunctionImplementation
singleton =
    { name = Syntax.fakeNode "List.singleton"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "value") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.ListExpr
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "value")
                ]
            )
    }


repeat : Elm.Syntax.Expression.FunctionImplementation
repeat =
    { name = Syntax.fakeNode "List.repeat"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "value")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "repeatHelp")
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                , Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "n")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "value")
                ]
            )
    }


repeatHelp : Elm.Syntax.Expression.FunctionImplementation
repeatHelp =
    { name = Syntax.fakeNode "List.repeatHelp"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "result")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "value")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "result")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                []
                                "repeatHelp"
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "cons"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "value"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "result"
                                            )
                                        ]
                                    )
                                )
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "-"
                                        Elm.Syntax.Infix.Left
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "n"
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Integer 1)
                                        )
                                    )
                                )
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "value")
                        ]
                    )
                )
            )
    }


range : Elm.Syntax.Expression.FunctionImplementation
range =
    { name = Syntax.fakeNode "List.range"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "lo")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "hi")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "rangeHelp")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "lo")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "hi")
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


rangeHelp : Elm.Syntax.Expression.FunctionImplementation
rangeHelp =
    { name = Syntax.fakeNode "List.rangeHelp"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "lo")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "hi")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "lo")
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "hi")
                        )
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                []
                                "rangeHelp"
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "lo")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "-"
                                        Elm.Syntax.Infix.Left
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "hi"
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Integer 1)
                                        )
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
                                                "cons"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "hi"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "list"
                                            )
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "list")
                )
            )
    }


cons : Elm.Syntax.Expression.FunctionImplementation
cons =
    { name = Syntax.fakeNode "List.cons"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "cons"
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = Syntax.fakeNode "List.map"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldr")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "acc")
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "cons"
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
                                                                    "x"
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "acc"
                                                )
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                ]
            )
    }


indexedMap : Elm.Syntax.Expression.FunctionImplementation
indexedMap =
    { name = Syntax.fakeNode "List.indexedMap"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "map2")
                , Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "f")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "range"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.Integer 0)
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "-"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "length"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "xs"
                                                            )
                                                        ]
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Integer
                                                        1
                                                    )
                                                )
                                            )
                                        )
                                    )
                                ]
                            )
                        )
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                ]
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = Syntax.fakeNode "List.foldl"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "acc")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "list")
                , cases =
                    [ ( Syntax.fakeNode (Elm.Syntax.Pattern.ListPattern [])
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "acc")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.UnConsPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
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
                                        "func"
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
                                                        "x"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "acc"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "xs"
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
    { name = Syntax.fakeNode "List.foldr"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "fn")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "acc")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ls")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldrHelper")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "fn")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "acc")
                , Syntax.fakeNode (Elm.Syntax.Expression.Integer 0)
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "ls")
                ]
            )
    }


foldrHelper : Elm.Syntax.Expression.FunctionImplementation
foldrHelper =
    { name = Syntax.fakeNode "List.foldrHelper"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "fn")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "acc")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ctr")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ls")
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
                            (Elm.Syntax.Expression.FunctionOrValue [] "acc")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.UnConsPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "r1")
                                )
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "r1"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.ListPattern [])
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "fn"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "a"
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
                                                        "b"
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "r2"
                                                    )
                                                )
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "r2"
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
                                                                        []
                                                                        "fn"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "a"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "fn"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "b"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "acc"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "c"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "r3"
                                                                    )
                                                                )
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "r3"
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
                                                                                        []
                                                                                        "fn"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "a"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "fn"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "b"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "fn"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "c"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "acc"
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
                                                                      )
                                                                    , ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "d"
                                                                                    )
                                                                                )
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "r4"
                                                                                    )
                                                                                )
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.LetExpression
                                                                                { declarations =
                                                                                    [ Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.LetFunction
                                                                                            { documentation =
                                                                                                Nothing
                                                                                            , signature =
                                                                                                Nothing
                                                                                            , declaration =
                                                                                                Syntax.fakeNode
                                                                                                    { name =
                                                                                                        Syntax.fakeNode
                                                                                                            "res"
                                                                                                    , arguments =
                                                                                                        []
                                                                                                    , expression =
                                                                                                        Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.IfBlock
                                                                                                                (Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                                                        ">"
                                                                                                                        Elm.Syntax.Infix.Left
                                                                                                                        (Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                []
                                                                                                                                "ctr"
                                                                                                                            )
                                                                                                                        )
                                                                                                                        (Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.Integer
                                                                                                                                500
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                )
                                                                                                                (Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                        [ Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                []
                                                                                                                                "foldl"
                                                                                                                            )
                                                                                                                        , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                []
                                                                                                                                "fn"
                                                                                                                            )
                                                                                                                        , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                []
                                                                                                                                "acc"
                                                                                                                            )
                                                                                                                        , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                                        [ Syntax.fakeNode
                                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                []
                                                                                                                                                "reverse"
                                                                                                                                            )
                                                                                                                                        , Syntax.fakeNode
                                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                []
                                                                                                                                                "r4"
                                                                                                                                            )
                                                                                                                                        ]
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        ]
                                                                                                                    )
                                                                                                                )
                                                                                                                (Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                        [ Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                []
                                                                                                                                "foldrHelper"
                                                                                                                            )
                                                                                                                        , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                []
                                                                                                                                "fn"
                                                                                                                            )
                                                                                                                        , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                []
                                                                                                                                "acc"
                                                                                                                            )
                                                                                                                        , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                        "+"
                                                                                                                                        Elm.Syntax.Infix.Left
                                                                                                                                        (Syntax.fakeNode
                                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                []
                                                                                                                                                "ctr"
                                                                                                                                            )
                                                                                                                                        )
                                                                                                                                        (Syntax.fakeNode
                                                                                                                                            (Elm.Syntax.Expression.Integer
                                                                                                                                                1
                                                                                                                                            )
                                                                                                                                        )
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                []
                                                                                                                                "r4"
                                                                                                                            )
                                                                                                                        ]
                                                                                                                    )
                                                                                                                )
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
                                                                                                    "fn"
                                                                                                )
                                                                                            , Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    []
                                                                                                    "a"
                                                                                                )
                                                                                            , Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                    (Syntax.fakeNode
                                                                                                        (Elm.Syntax.Expression.Application
                                                                                                            [ Syntax.fakeNode
                                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                    []
                                                                                                                    "fn"
                                                                                                                )
                                                                                                            , Syntax.fakeNode
                                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                    []
                                                                                                                    "b"
                                                                                                                )
                                                                                                            , Syntax.fakeNode
                                                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                    (Syntax.fakeNode
                                                                                                                        (Elm.Syntax.Expression.Application
                                                                                                                            [ Syntax.fakeNode
                                                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                    []
                                                                                                                                    "fn"
                                                                                                                                )
                                                                                                                            , Syntax.fakeNode
                                                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                    []
                                                                                                                                    "c"
                                                                                                                                )
                                                                                                                            , Syntax.fakeNode
                                                                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                                    (Syntax.fakeNode
                                                                                                                                        (Elm.Syntax.Expression.Application
                                                                                                                                            [ Syntax.fakeNode
                                                                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                    []
                                                                                                                                                    "fn"
                                                                                                                                                )
                                                                                                                                            , Syntax.fakeNode
                                                                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                    []
                                                                                                                                                    "d"
                                                                                                                                                )
                                                                                                                                            , Syntax.fakeNode
                                                                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                                    []
                                                                                                                                                    "res"
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


filter : Elm.Syntax.Expression.FunctionImplementation
filter =
    { name = Syntax.fakeNode "List.filter"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "isGood")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldr")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "xs")
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.IfBlock
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Application
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "isGood"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "x"
                                                        )
                                                    ]
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Application
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "cons"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "x"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "xs"
                                                        )
                                                    ]
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "xs"
                                                )
                                            )
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "list")
                ]
            )
    }


filterMap : Elm.Syntax.Expression.FunctionImplementation
filterMap =
    { name = Syntax.fakeNode "List.filterMap"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldr")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "maybeCons"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "f"
                                    )
                                ]
                            )
                        )
                    )
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                ]
            )
    }


maybeCons : Elm.Syntax.Expression.FunctionImplementation
maybeCons =
    { name = Syntax.fakeNode "List.maybeCons"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "mx")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "f")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "mx")
                            ]
                        )
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "cons"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "x"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "xs"
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
                            (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                      )
                    ]
                }
            )
    }


length : Elm.Syntax.Expression.FunctionImplementation
length =
    { name = Syntax.fakeNode "List.length"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldl")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ Syntax.fakeNode
                                        Elm.Syntax.Pattern.AllPattern
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "i")
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "+"
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "i"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Integer 1
                                                )
                                            )
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode (Elm.Syntax.Expression.Integer 0)
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                ]
            )
    }


reverse : Elm.Syntax.Expression.FunctionImplementation
reverse =
    { name = Syntax.fakeNode "List.reverse"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldl")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "cons")
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "list")
                ]
            )
    }


member : Elm.Syntax.Expression.FunctionImplementation
member =
    { name = Syntax.fakeNode "List.member"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "any")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "a")
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "=="
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "a"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "x"
                                                )
                                            )
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


all : Elm.Syntax.Expression.FunctionImplementation
all =
    { name = Syntax.fakeNode "List.all"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "isOkay")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "not")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "any"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<<"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "not"
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "isOkay"
                                                    )
                                                )
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "list"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


any : Elm.Syntax.Expression.FunctionImplementation
any =
    { name = Syntax.fakeNode "List.any"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "isOkay")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "list")
                , cases =
                    [ ( Syntax.fakeNode (Elm.Syntax.Pattern.ListPattern [])
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "False")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.UnConsPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.IfBlock
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "isOkay"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "x"
                                            )
                                        ]
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "True"
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "any"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "isOkay"
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
                      )
                    ]
                }
            )
    }


maximum : Elm.Syntax.Expression.FunctionImplementation
maximum =
    { name = Syntax.fakeNode "List.maximum"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "list")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.UnConsPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
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
                                                        "foldl"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "max"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "x"
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
                            )
                      )
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    ]
                }
            )
    }


minimum : Elm.Syntax.Expression.FunctionImplementation
minimum =
    { name = Syntax.fakeNode "List.minimum"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "list")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.UnConsPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
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
                                                        "foldl"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "min"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "x"
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
                            )
                      )
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    ]
                }
            )
    }


sum : Elm.Syntax.Expression.FunctionImplementation
sum =
    { name = Syntax.fakeNode "List.sum"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "numbers") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldl")
                , Syntax.fakeNode (Elm.Syntax.Expression.PrefixOperator "+")
                , Syntax.fakeNode (Elm.Syntax.Expression.Integer 0)
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "numbers")
                ]
            )
    }


product : Elm.Syntax.Expression.FunctionImplementation
product =
    { name = Syntax.fakeNode "List.product"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "numbers") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldl")
                , Syntax.fakeNode (Elm.Syntax.Expression.PrefixOperator "*")
                , Syntax.fakeNode (Elm.Syntax.Expression.Integer 1)
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "numbers")
                ]
            )
    }


append : Elm.Syntax.Expression.FunctionImplementation
append =
    { name = Syntax.fakeNode "List.append"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ys")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "ys")
                , cases =
                    [ ( Syntax.fakeNode (Elm.Syntax.Pattern.ListPattern [])
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                      )
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
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
                                        "cons"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "ys"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "xs"
                                    )
                                ]
                            )
                      )
                    ]
                }
            )
    }


concat : Elm.Syntax.Expression.FunctionImplementation
concat =
    { name = Syntax.fakeNode "List.concat"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "lists") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldr")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "append")
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "lists")
                ]
            )
    }


concatMap : Elm.Syntax.Expression.FunctionImplementation
concatMap =
    { name = Syntax.fakeNode "List.concatMap"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "concat")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "map"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "f"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "list"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


intersperse : Elm.Syntax.Expression.FunctionImplementation
intersperse =
    { name = Syntax.fakeNode "List.intersperse"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "sep")
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
                      , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.UnConsPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "hd")
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "tl")
                                )
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                Syntax.fakeNode
                                                    { name =
                                                        Syntax.fakeNode "step"
                                                    , arguments =
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "x"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "rest"
                                                            )
                                                        ]
                                                    , expression =
                                                        Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "cons"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "sep"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "cons"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "x"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "rest"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                ]
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
                                                    { name =
                                                        Syntax.fakeNode
                                                            "spersed"
                                                    , arguments = []
                                                    , expression =
                                                        Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "foldr"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "step"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ListExpr
                                                                        []
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "tl"
                                                                    )
                                                                ]
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
                                                    "cons"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "hd"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "spersed"
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


map2 : Elm.Syntax.Expression.FunctionImplementation
map2 =
    { name = Syntax.fakeNode "List.map2"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "map2"
            )
    }


map3 : Elm.Syntax.Expression.FunctionImplementation
map3 =
    { name = Syntax.fakeNode "List.map3"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "map3"
            )
    }


map4 : Elm.Syntax.Expression.FunctionImplementation
map4 =
    { name = Syntax.fakeNode "List.map4"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "map4"
            )
    }


map5 : Elm.Syntax.Expression.FunctionImplementation
map5 =
    { name = Syntax.fakeNode "List.map5"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "map5"
            )
    }


sort : Elm.Syntax.Expression.FunctionImplementation
sort =
    { name = Syntax.fakeNode "List.sort"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "sortBy")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "identity")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                ]
            )
    }


sortBy : Elm.Syntax.Expression.FunctionImplementation
sortBy =
    { name = Syntax.fakeNode "List.sortBy"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "sortBy"
            )
    }


sortWith : Elm.Syntax.Expression.FunctionImplementation
sortWith =
    { name = Syntax.fakeNode "List.sortWith"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "sortWith"
            )
    }


isEmpty : Elm.Syntax.Expression.FunctionImplementation
isEmpty =
    { name = Syntax.fakeNode "List.isEmpty"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "xs") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "xs")
                , cases =
                    [ ( Syntax.fakeNode (Elm.Syntax.Pattern.ListPattern [])
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "True")
                      )
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "False")
                      )
                    ]
                }
            )
    }


head : Elm.Syntax.Expression.FunctionImplementation
head =
    { name = Syntax.fakeNode "List.head"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "list")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.UnConsPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
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
                                        "x"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode (Elm.Syntax.Pattern.ListPattern [])
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    ]
                }
            )
    }


tail : Elm.Syntax.Expression.FunctionImplementation
tail =
    { name = Syntax.fakeNode "List.tail"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "list")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.UnConsPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
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
                                        "xs"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode (Elm.Syntax.Pattern.ListPattern [])
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    ]
                }
            )
    }


take : Elm.Syntax.Expression.FunctionImplementation
take =
    { name = Syntax.fakeNode "List.take"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "takeFast")
                , Syntax.fakeNode (Elm.Syntax.Expression.Integer 0)
                , Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "n")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "list")
                ]
            )
    }


takeFast : Elm.Syntax.Expression.FunctionImplementation
takeFast =
    { name = Syntax.fakeNode "List.takeFast"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "ctr")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (Syntax.fakeNode (Elm.Syntax.Expression.ListExpr []))
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.CaseExpression
                        { expression =
                            Syntax.fakeNode
                                (Elm.Syntax.Expression.TupledExpression
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "n"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "list"
                                        )
                                    ]
                                )
                        , cases =
                            [ ( Syntax.fakeNode
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.ListPattern [])
                                        ]
                                    )
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "list"
                                    )
                              )
                            , ( Syntax.fakeNode
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.IntPattern 1)
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.UnConsPattern
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    Elm.Syntax.Pattern.AllPattern
                                                )
                                            )
                                        ]
                                    )
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ListExpr
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "x"
                                            )
                                        ]
                                    )
                              )
                            , ( Syntax.fakeNode
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.IntPattern 2)
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.UnConsPattern
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.UnConsPattern
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "y"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            Elm.Syntax.Pattern.AllPattern
                                                        )
                                                    )
                                                )
                                            )
                                        ]
                                    )
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ListExpr
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "x"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "y"
                                            )
                                        ]
                                    )
                              )
                            , ( Syntax.fakeNode
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.IntPattern 3)
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.UnConsPattern
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.UnConsPattern
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "y"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "z"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        ]
                                    )
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ListExpr
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "x"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "y"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "z"
                                            )
                                        ]
                                    )
                              )
                            , ( Syntax.fakeNode
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.UnConsPattern
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.UnConsPattern
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "y"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "z"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.UnConsPattern
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "w"
                                                                            )
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "tl"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        ]
                                    )
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.IfBlock
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                ">"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "ctr"
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Integer
                                                        1000
                                                    )
                                                )
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "cons"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "x"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "cons"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "y"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "cons"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "z"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "cons"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "w"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "takeTailRec"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                        (Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                "-"
                                                                                                                                Elm.Syntax.Infix.Left
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "n"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.Integer
                                                                                                                                        4
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "tl"
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
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "cons"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "x"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "cons"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "y"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "cons"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "z"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "cons"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "w"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "takeFast"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                        (Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                "+"
                                                                                                                                Elm.Syntax.Infix.Left
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "ctr"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.Integer
                                                                                                                                        1
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                        (Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                "-"
                                                                                                                                Elm.Syntax.Infix.Left
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "n"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.Integer
                                                                                                                                        4
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "tl"
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
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                        )
                                    )
                              )
                            , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "list"
                                    )
                              )
                            ]
                        }
                    )
                )
            )
    }


takeTailRec : Elm.Syntax.Expression.FunctionImplementation
takeTailRec =
    { name = Syntax.fakeNode "List.takeTailRec"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "reverse")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "takeReverse"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "n"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "list"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ListExpr [])
                                ]
                            )
                        )
                    )
                ]
            )
    }


takeReverse : Elm.Syntax.Expression.FunctionImplementation
takeReverse =
    { name = Syntax.fakeNode "List.takeReverse"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "kept")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "kept")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.CaseExpression
                        { expression =
                            Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "list"
                                )
                        , cases =
                            [ ( Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ListPattern [])
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "kept"
                                    )
                              )
                            , ( Syntax.fakeNode
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "xs")
                                        )
                                    )
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "takeReverse"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "n"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Integer
                                                                1
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "xs"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "cons"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "x"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "kept"
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
            )
    }


drop : Elm.Syntax.Expression.FunctionImplementation
drop =
    { name = Syntax.fakeNode "List.drop"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "list")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.CaseExpression
                        { expression =
                            Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "list"
                                )
                        , cases =
                            [ ( Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ListPattern [])
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "list"
                                    )
                              )
                            , ( Syntax.fakeNode
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "xs")
                                        )
                                    )
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "drop"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "n"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Integer
                                                                1
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "xs"
                                            )
                                        ]
                                    )
                              )
                            ]
                        }
                    )
                )
            )
    }


partition : Elm.Syntax.Expression.FunctionImplementation
partition =
    { name = Syntax.fakeNode "List.partition"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "pred")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
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
                                    { name = Syntax.fakeNode "step"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "trues"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "falses"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.IfBlock
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "pred"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "x"
                                                            )
                                                        ]
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.TupledExpression
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "cons"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "x"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "trues"
                                                                    )
                                                                ]
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "falses"
                                                            )
                                                        ]
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.TupledExpression
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "trues"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "cons"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "x"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "falses"
                                                                    )
                                                                ]
                                                            )
                                                        ]
                                                    )
                                                )
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
                                    "foldr"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "step"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.TupledExpression
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.ListExpr [])
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.ListExpr [])
                                    ]
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "list"
                                )
                            ]
                        )
                }
            )
    }


unzip : Elm.Syntax.Expression.FunctionImplementation
unzip =
    { name = Syntax.fakeNode "List.unzip"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "pairs") ]
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
                                    { name = Syntax.fakeNode "step"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "y"
                                                    )
                                                ]
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "xs"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "ys"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.TupledExpression
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "cons"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "x"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "xs"
                                                            )
                                                        ]
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "cons"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "y"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "ys"
                                                            )
                                                        ]
                                                    )
                                                ]
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
                                    "foldr"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "step"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.TupledExpression
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.ListExpr [])
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.ListExpr [])
                                    ]
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "pairs"
                                )
                            ]
                        )
                }
            )
    }