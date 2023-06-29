module Core.Dict exposing (balance, diff, empty, filter, foldl, foldr, fromList, functions, get, getMin, insert, insertHelp, intersect, isEmpty, keys, map, member, merge, moveRedLeft, moveRedRight, partition, remove, removeHelp, removeHelpEQGT, removeHelpPrepEQGT, removeMin, singleton, size, sizeHelp, toList, union, update, values)

{-| 
@docs functions, empty, get, member, size, sizeHelp, isEmpty, insert, insertHelp, balance, remove, removeHelp, removeHelpPrepEQGT, removeHelpEQGT, getMin, removeMin, moveRedLeft, moveRedRight, update, singleton, union, intersect, diff, merge, map, foldl, foldr, filter, partition, keys, values, toList, fromList
-}


import Elm.Syntax.Expression
import Elm.Syntax.Infix
import Elm.Syntax.Pattern
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "empty", empty )
        , ( "get", get )
        , ( "member", member )
        , ( "size", size )
        , ( "sizeHelp", sizeHelp )
        , ( "isEmpty", isEmpty )
        , ( "insert", insert )
        , ( "insertHelp", insertHelp )
        , ( "balance", balance )
        , ( "remove", remove )
        , ( "removeHelp", removeHelp )
        , ( "removeHelpPrepEQGT", removeHelpPrepEQGT )
        , ( "removeHelpEQGT", removeHelpEQGT )
        , ( "getMin", getMin )
        , ( "removeMin", removeMin )
        , ( "moveRedLeft", moveRedLeft )
        , ( "moveRedRight", moveRedRight )
        , ( "update", update )
        , ( "singleton", singleton )
        , ( "union", union )
        , ( "intersect", intersect )
        , ( "diff", diff )
        , ( "merge", merge )
        , ( "map", map )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        , ( "filter", filter )
        , ( "partition", partition )
        , ( "keys", keys )
        , ( "values", values )
        , ( "toList", toList )
        , ( "fromList", fromList )
        ]


empty : Elm.Syntax.Expression.FunctionImplementation
empty =
    { name = Syntax.fakeNode "Dict.empty"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue [] "RBEmpty_elm_builtin")
    }


get : Elm.Syntax.Expression.FunctionImplementation
get =
    { name = Syntax.fakeNode "Dict.get"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "targetKey")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "compare"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "targetKey"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "key"
                                                )
                                            ]
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "LT" }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "get"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "targetKey"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "left"
                                                    )
                                                ]
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "EQ" }
                                                []
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
                                                        "value"
                                                    )
                                                ]
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "GT" }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "get"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "targetKey"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "right"
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


member : Elm.Syntax.Expression.FunctionImplementation
member =
    { name = Syntax.fakeNode "Dict.member"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "key")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "get")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "key")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "dict"
                                )
                            ]
                        )
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


size : Elm.Syntax.Expression.FunctionImplementation
size =
    { name = Syntax.fakeNode "Dict.size"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "sizeHelp")
                , Syntax.fakeNode (Elm.Syntax.Expression.Integer 0)
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                ]
            )
    }


sizeHelp : Elm.Syntax.Expression.FunctionImplementation
sizeHelp =
    { name = Syntax.fakeNode "Dict.sizeHelp"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "sizeHelp"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "sizeHelp"
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
                                                        "right"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "left"
                                    )
                                ]
                            )
                      )
                    ]
                }
            )
    }


isEmpty : Elm.Syntax.Expression.FunctionImplementation
isEmpty =
    { name = Syntax.fakeNode "Dict.isEmpty"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "True")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "False")
                      )
                    ]
                }
            )
    }


insert : Elm.Syntax.Expression.FunctionImplementation
insert =
    { name = Syntax.fakeNode "Dict.insert"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "key")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "value")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "insertHelp"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "key")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "value"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "dict"
                                )
                            ]
                        )
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "Red" }
                                        []
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "l")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "r")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "RBNode_elm_builtin"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Black"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "k"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "v"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "l"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "r"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "x")
                      )
                    ]
                }
            )
    }


insertHelp : Elm.Syntax.Expression.FunctionImplementation
insertHelp =
    { name = Syntax.fakeNode "Dict.insertHelp"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "key")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "value")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "RBNode_elm_builtin"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Red"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "key"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "value"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "RBEmpty_elm_builtin"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "RBEmpty_elm_builtin"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "nColor")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "nKey")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "nValue")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "nLeft")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "nRight")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "compare"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "key"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "nKey"
                                                )
                                            ]
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "LT" }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "balance"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nColor"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nKey"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nValue"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "insertHelp"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "key"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "value"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "nLeft"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nRight"
                                                    )
                                                ]
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "EQ" }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nColor"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nKey"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "value"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nLeft"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nRight"
                                                    )
                                                ]
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "GT" }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "balance"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nColor"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nKey"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nValue"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nLeft"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "insertHelp"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "key"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "value"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "nRight"
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


balance : Elm.Syntax.Expression.FunctionImplementation
balance =
    { name = Syntax.fakeNode "Dict.balance"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "color")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "key")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "value")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "left")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "right")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "right")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "Red" }
                                        []
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "rK")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "rV")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "rLeft")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "rRight")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "left"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name = "Red"
                                                        }
                                                        []
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lLeft"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Red"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "key"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "value"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Black"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lRight"
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
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Black"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "color"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "rK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "rV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Red"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "key"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "value"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "left"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rLeft"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "rRight"
                                                    )
                                                ]
                                            )
                                      )
                                    ]
                                }
                            )
                      )
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "left"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name = "Red"
                                                        }
                                                        []
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Red"
                                                                        }
                                                                        []
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Red"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "lK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "lV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Black"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "llK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "llV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "llLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "llRight"
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
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Black"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "key"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "value"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lRight"
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
                                      )
                                    , ( Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "color"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "key"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "value"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "left"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "right"
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


remove : Elm.Syntax.Expression.FunctionImplementation
remove =
    { name = Syntax.fakeNode "Dict.remove"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "key")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "removeHelp"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "key")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "dict"
                                )
                            ]
                        )
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "Red" }
                                        []
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "l")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "r")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "RBNode_elm_builtin"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Black"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "k"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "v"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "l"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "r"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "x")
                      )
                    ]
                }
            )
    }


removeHelp : Elm.Syntax.Expression.FunctionImplementation
removeHelp =
    { name = Syntax.fakeNode "Dict.removeHelp"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "targetKey")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                []
                                "RBEmpty_elm_builtin"
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "color")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.IfBlock
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "<"
                                        Elm.Syntax.Infix.Left
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "targetKey"
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "key"
                                            )
                                        )
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.CaseExpression
                                        { expression =
                                            Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "left"
                                                )
                                        , cases =
                                            [ ( Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name =
                                                            "RBNode_elm_builtin"
                                                        }
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Black"
                                                                }
                                                                []
                                                            )
                                                        , Syntax.fakeNode
                                                            Elm.Syntax.Pattern.AllPattern
                                                        , Syntax.fakeNode
                                                            Elm.Syntax.Pattern.AllPattern
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "lLeft"
                                                            )
                                                        , Syntax.fakeNode
                                                            Elm.Syntax.Pattern.AllPattern
                                                        ]
                                                    )
                                              , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.CaseExpression
                                                        { expression =
                                                            Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "lLeft"
                                                                )
                                                        , cases =
                                                            [ ( Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "RBNode_elm_builtin"
                                                                        }
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Red"
                                                                                }
                                                                                []
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            Elm.Syntax.Pattern.AllPattern
                                                                        , Syntax.fakeNode
                                                                            Elm.Syntax.Pattern.AllPattern
                                                                        , Syntax.fakeNode
                                                                            Elm.Syntax.Pattern.AllPattern
                                                                        , Syntax.fakeNode
                                                                            Elm.Syntax.Pattern.AllPattern
                                                                        ]
                                                                    )
                                                              , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "RBNode_elm_builtin"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "color"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "key"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "value"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "removeHelp"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "targetKey"
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
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "right"
                                                                            )
                                                                        ]
                                                                    )
                                                              )
                                                            , ( Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                              , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.CaseExpression
                                                                        { expression =
                                                                            Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.Application
                                                                                    [ Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                            []
                                                                                            "moveRedLeft"
                                                                                        )
                                                                                    , Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                            []
                                                                                            "dict"
                                                                                        )
                                                                                    ]
                                                                                )
                                                                        , cases =
                                                                            [ ( Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                                        { moduleName =
                                                                                            []
                                                                                        , name =
                                                                                            "RBNode_elm_builtin"
                                                                                        }
                                                                                        [ Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "nColor"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "nKey"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "nValue"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "nLeft"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "nRight"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                              , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "balance"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "nColor"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "nKey"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "nValue"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                        [ Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "removeHelp"
                                                                                                            )
                                                                                                        , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "targetKey"
                                                                                                            )
                                                                                                        , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "nLeft"
                                                                                                            )
                                                                                                        ]
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "nRight"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                              )
                                                                            , ( Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                                        { moduleName =
                                                                                            []
                                                                                        , name =
                                                                                            "RBEmpty_elm_builtin"
                                                                                        }
                                                                                        []
                                                                                    )
                                                                              , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "RBEmpty_elm_builtin"
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
                                            , ( Syntax.fakeNode
                                                    Elm.Syntax.Pattern.AllPattern
                                              , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "RBNode_elm_builtin"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "color"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "key"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "value"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "removeHelp"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "targetKey"
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
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "right"
                                                            )
                                                        ]
                                                    )
                                              )
                                            ]
                                        }
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "removeHelpEQGT"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "targetKey"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "removeHelpPrepEQGT"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "targetKey"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "dict"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "color"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "key"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "value"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "left"
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
                                )
                            )
                      )
                    ]
                }
            )
    }


removeHelpPrepEQGT : Elm.Syntax.Expression.FunctionImplementation
removeHelpPrepEQGT =
    { name = Syntax.fakeNode "Dict.removeHelpPrepEQGT"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "targetKey")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "color")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "key")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "value")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "left")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "right")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "left")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "Red" }
                                        []
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "lK")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "lV")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "lLeft")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "lRight")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "RBNode_elm_builtin"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "color"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "lK"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "lV"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "lLeft"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Red"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "key"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "value"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "lRight"
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
                      )
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "right"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name = "Black"
                                                        }
                                                        []
                                                    )
                                                , Syntax.fakeNode
                                                    Elm.Syntax.Pattern.AllPattern
                                                , Syntax.fakeNode
                                                    Elm.Syntax.Pattern.AllPattern
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Black"
                                                                        }
                                                                        []
                                                                    )
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , Syntax.fakeNode
                                                    Elm.Syntax.Pattern.AllPattern
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "moveRedRight"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "dict"
                                                    )
                                                ]
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name = "Black"
                                                        }
                                                        []
                                                    )
                                                , Syntax.fakeNode
                                                    Elm.Syntax.Pattern.AllPattern
                                                , Syntax.fakeNode
                                                    Elm.Syntax.Pattern.AllPattern
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name =
                                                            "RBEmpty_elm_builtin"
                                                        }
                                                        []
                                                    )
                                                , Syntax.fakeNode
                                                    Elm.Syntax.Pattern.AllPattern
                                                ]
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "moveRedRight"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "dict"
                                                    )
                                                ]
                                            )
                                      )
                                    , ( Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "dict"
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


removeHelpEQGT : Elm.Syntax.Expression.FunctionImplementation
removeHelpEQGT =
    { name = Syntax.fakeNode "Dict.removeHelpEQGT"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "targetKey")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "color")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.IfBlock
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "=="
                                        Elm.Syntax.Infix.Left
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "targetKey"
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "key"
                                            )
                                        )
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.CaseExpression
                                        { expression =
                                            Syntax.fakeNode
                                                (Elm.Syntax.Expression.Application
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "getMin"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "right"
                                                        )
                                                    ]
                                                )
                                        , cases =
                                            [ ( Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name =
                                                            "RBNode_elm_builtin"
                                                        }
                                                        [ Syntax.fakeNode
                                                            Elm.Syntax.Pattern.AllPattern
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "minKey"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "minValue"
                                                            )
                                                        , Syntax.fakeNode
                                                            Elm.Syntax.Pattern.AllPattern
                                                        , Syntax.fakeNode
                                                            Elm.Syntax.Pattern.AllPattern
                                                        ]
                                                    )
                                              , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "balance"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "color"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "minKey"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "minValue"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "left"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "removeMin"
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
                                              )
                                            , ( Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name =
                                                            "RBEmpty_elm_builtin"
                                                        }
                                                        []
                                                    )
                                              , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBEmpty_elm_builtin"
                                                    )
                                              )
                                            ]
                                        }
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "balance"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "color"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "key"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "value"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "left"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "removeHelp"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "targetKey"
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
                                )
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                []
                                "RBEmpty_elm_builtin"
                            )
                      )
                    ]
                }
            )
    }


getMin : Elm.Syntax.Expression.FunctionImplementation
getMin =
    { name = Syntax.fakeNode "Dict.getMin"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.AsPattern
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
                                                            )
                                                        )
                                                    )
                                                )
                                                (Syntax.fakeNode "left")
                                            )
                                        )
                                    )
                                , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "getMin"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "left"
                                    )
                                ]
                            )
                      )
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                      )
                    ]
                }
            )
    }


removeMin : Elm.Syntax.Expression.FunctionImplementation
removeMin =
    { name = Syntax.fakeNode "Dict.removeMin"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "color")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.AsPattern
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lColor"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
                                                            )
                                                        )
                                                    )
                                                )
                                                (Syntax.fakeNode "left")
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "lColor"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Black"
                                                }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "lLeft"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Red"
                                                                        }
                                                                        []
                                                                    )
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "color"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "key"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "value"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "removeMin"
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
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "right"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            Elm.Syntax.Pattern.AllPattern
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "moveRedLeft"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "dict"
                                                                                )
                                                                            ]
                                                                        )
                                                                , cases =
                                                                    [ ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "RBNode_elm_builtin"
                                                                                }
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "nColor"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "nKey"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "nValue"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "nLeft"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "nRight"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "balance"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "nColor"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "nKey"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "nValue"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "removeMin"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "nLeft"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "nRight"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "RBEmpty_elm_builtin"
                                                                                }
                                                                                []
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "RBEmpty_elm_builtin"
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
                                    , ( Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "color"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "key"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "value"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "removeMin"
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
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "right"
                                                    )
                                                ]
                                            )
                                      )
                                    ]
                                }
                            )
                      )
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                []
                                "RBEmpty_elm_builtin"
                            )
                      )
                    ]
                }
            )
    }


moveRedLeft : Elm.Syntax.Expression.FunctionImplementation
moveRedLeft =
    { name = Syntax.fakeNode "Dict.moveRedLeft"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "clr")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lClr"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lLeft"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rClr"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.AsPattern
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "RBNode_elm_builtin"
                                                                                }
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                                        { moduleName =
                                                                                            []
                                                                                        , name =
                                                                                            "Red"
                                                                                        }
                                                                                        []
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "rlK"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "rlV"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "rlL"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "rlR"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    "rLeft"
                                                                )
                                                            )
                                                        )
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "RBNode_elm_builtin"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Red"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "rlK"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "rlV"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Black"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "k"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "v"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Red"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "rlL"
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
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Black"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "rK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "rV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "rlR"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "rRight"
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
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "clr")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lClr"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lLeft"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rClr"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rLeft"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "clr"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Black"
                                                }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Black"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "k"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "v"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Red"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lRight"
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
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Red"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rRight"
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
                                                { moduleName = []
                                                , name = "Red"
                                                }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Black"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "k"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "v"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Red"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lRight"
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
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Red"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rRight"
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
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                      )
                    ]
                }
            )
    }


moveRedRight : Elm.Syntax.Expression.FunctionImplementation
moveRedRight =
    { name = Syntax.fakeNode "Dict.moveRedRight"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "clr")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lClr"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Red"
                                                                        }
                                                                        []
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rClr"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rLeft"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "RBNode_elm_builtin"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Red"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "lK"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "lV"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Black"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "llK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "llV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "llLeft"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "llRight"
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
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Black"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "k"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "v"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "lRight"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Red"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rRight"
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
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "clr")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lClr"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lLeft"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rClr"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rK"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rV"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rLeft"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "clr"
                                        )
                                , cases =
                                    [ ( Syntax.fakeNode
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Black"
                                                }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Black"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "k"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "v"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Red"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lRight"
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
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Red"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rRight"
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
                                                { moduleName = []
                                                , name = "Red"
                                                }
                                                []
                                            )
                                      , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "RBNode_elm_builtin"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "Black"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "k"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "v"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Red"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lRight"
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
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Red"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rK"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rV"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rLeft"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "rRight"
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
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                      )
                    ]
                }
            )
    }


update : Elm.Syntax.Expression.FunctionImplementation
update =
    { name = Syntax.fakeNode "Dict.update"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "targetKey")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "alter")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dictionary")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "alter"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "get"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "targetKey"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "dictionary"
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
                                        "insert"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "targetKey"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "value"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "dictionary"
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
                                        "remove"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "targetKey"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "dictionary"
                                    )
                                ]
                            )
                      )
                    ]
                }
            )
    }


singleton : Elm.Syntax.Expression.FunctionImplementation
singleton =
    { name = Syntax.fakeNode "Dict.singleton"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "key")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "value")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue
                        []
                        "RBNode_elm_builtin"
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "Black")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "key")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "value")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue
                        []
                        "RBEmpty_elm_builtin"
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue
                        []
                        "RBEmpty_elm_builtin"
                    )
                ]
            )
    }


union : Elm.Syntax.Expression.FunctionImplementation
union =
    { name = Syntax.fakeNode "Dict.union"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "t1")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "t2")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldl")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "insert")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "t2")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "t1")
                ]
            )
    }


intersect : Elm.Syntax.Expression.FunctionImplementation
intersect =
    { name = Syntax.fakeNode "Dict.intersect"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "t1")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "t2")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "filter")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "k")
                                    , Syntax.fakeNode
                                        Elm.Syntax.Pattern.AllPattern
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "member"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "k"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "t2"
                                                )
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "t1")
                ]
            )
    }


diff : Elm.Syntax.Expression.FunctionImplementation
diff =
    { name = Syntax.fakeNode "Dict.diff"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "t1")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "t2")
        ]
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
                                        (Elm.Syntax.Pattern.VarPattern "k")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "v")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "t")
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "remove"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "k"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "t"
                                                )
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "t1")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "t2")
                ]
            )
    }


merge : Elm.Syntax.Expression.FunctionImplementation
merge =
    { name = Syntax.fakeNode "Dict.merge"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "leftStep")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "bothStep")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rightStep")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "leftDict")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "rightDict")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "initialResult")
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
                                    { name = Syntax.fakeNode "stepState"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "rKey"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "rValue"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "list"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "result"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "list"
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
                                                                        "list"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "rightStep"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "rKey"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "rValue"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "result"
                                                                            )
                                                                        ]
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.TuplePattern
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "lKey"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "lValue"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "rest"
                                                                    )
                                                                )
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.IfBlock
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "<"
                                                                        Elm.Syntax.Infix.Left
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "lKey"
                                                                            )
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "rKey"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "stepState"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "rKey"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "rValue"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.TupledExpression
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "rest"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "leftStep"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "lKey"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "lValue"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "result"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                                ]
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.IfBlock
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                ">"
                                                                                Elm.Syntax.Infix.Left
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "lKey"
                                                                                    )
                                                                                )
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "rKey"
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.TupledExpression
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "list"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "rightStep"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "rKey"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "rValue"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "result"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.TupledExpression
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "rest"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "bothStep"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "lKey"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "lValue"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "rValue"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "result"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                      )
                                                    ]
                                                }
                                            )
                                    }
                            }
                        )
                    , Syntax.fakeNode
                        (Elm.Syntax.Expression.LetDestructuring
                            (Syntax.fakeNode
                                (Elm.Syntax.Pattern.TuplePattern
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern
                                            "leftovers"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern
                                            "intermediateResult"
                                        )
                                    ]
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
                                            "stepState"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.TupledExpression
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.Application
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "toList"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "leftDict"
                                                        )
                                                    ]
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "initialResult"
                                                )
                                            ]
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "rightDict"
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
                                    [ "List" ]
                                    "foldl"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.LambdaExpression
                                            { args =
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.TuplePattern
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "k"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "v"
                                                            )
                                                        ]
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "result"
                                                    )
                                                ]
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "leftStep"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "k"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "v"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "result"
                                                            )
                                                        ]
                                                    )
                                            }
                                        )
                                    )
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "intermediateResult"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "leftovers"
                                )
                            ]
                        )
                }
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = Syntax.fakeNode "Dict.map"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                []
                                "RBEmpty_elm_builtin"
                            )
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "color")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "RBNode_elm_builtin"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "color"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "key"
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
                                                        "key"
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
                                                        "func"
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
                                                        "map"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "func"
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
                      )
                    ]
                }
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = Syntax.fakeNode "Dict.foldl"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "acc")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "acc")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "right")
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
                                                        "key"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "value"
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
                                                                        "func"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "acc"
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
                                                ]
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "right"
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
    { name = Syntax.fakeNode "Dict.foldr"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "acc")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "t")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "t")
                , cases =
                    [ ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "acc")
                      )
                    , ( Syntax.fakeNode
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , Syntax.fakeNode
                                    (Elm.Syntax.Pattern.VarPattern "right")
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
                                                        "key"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "value"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "foldr"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "func"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "acc"
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
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "left"
                                    )
                                ]
                            )
                      )
                    ]
                }
            )
    }


filter : Elm.Syntax.Expression.FunctionImplementation
filter =
    { name = Syntax.fakeNode "Dict.filter"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "isGood")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
        ]
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
                                        (Elm.Syntax.Pattern.VarPattern "k")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "v")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "d")
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
                                                            "k"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "v"
                                                        )
                                                    ]
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Application
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "insert"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "k"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "v"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "d"
                                                        )
                                                    ]
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "d"
                                                )
                                            )
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "empty")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                ]
            )
    }


partition : Elm.Syntax.Expression.FunctionImplementation
partition =
    { name = Syntax.fakeNode "Dict.partition"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "isGood")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
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
                                    { name = Syntax.fakeNode "add"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "key"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "value"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "t1"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "t2"
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
                                                                "isGood"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "key"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "value"
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
                                                                        "insert"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "key"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "value"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "t1"
                                                                    )
                                                                ]
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "t2"
                                                            )
                                                        ]
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.TupledExpression
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "t1"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "insert"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "key"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "value"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "t2"
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
                                    "foldl"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "add")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.TupledExpression
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "empty"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "empty"
                                        )
                                    ]
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "dict"
                                )
                            ]
                        )
                }
            )
    }


keys : Elm.Syntax.Expression.FunctionImplementation
keys =
    { name = Syntax.fakeNode "Dict.keys"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict") ]
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
                                        (Elm.Syntax.Pattern.VarPattern "key")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "value")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "keyList"
                                        )
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "::"
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "key"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "keyList"
                                                )
                                            )
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                ]
            )
    }


values : Elm.Syntax.Expression.FunctionImplementation
values =
    { name = Syntax.fakeNode "Dict.values"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict") ]
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
                                        (Elm.Syntax.Pattern.VarPattern "key")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "value")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern
                                            "valueList"
                                        )
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "::"
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "value"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "valueList"
                                                )
                                            )
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                ]
            )
    }


toList : Elm.Syntax.Expression.FunctionImplementation
toList =
    { name = Syntax.fakeNode "Dict.toList"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict") ]
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
                                        (Elm.Syntax.Pattern.VarPattern "key")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "value")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "list")
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "::"
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.TupledExpression
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "key"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "value"
                                                        )
                                                    ]
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "list"
                                                )
                                            )
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                ]
            )
    }


fromList : Elm.Syntax.Expression.FunctionImplementation
fromList =
    { name = Syntax.fakeNode "Dict.fromList"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "assocs") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "foldl")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Pattern.TuplePattern
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "key"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "value"
                                                )
                                            ]
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "dict")
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "insert"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "key"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "value"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "dict"
                                                )
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "empty")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "assocs")
                ]
            )
    }