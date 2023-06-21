module Core.Set exposing (diff, empty, filter, foldl, foldr, fromList, functions, insert, intersect, isEmpty, map, member, partition, remove, singleton, size, toList, union)

{-| 
@docs functions, empty, singleton, insert, remove, isEmpty, member, size, union, intersect, diff, toList, fromList, foldl, foldr, map, filter, partition
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
        , ( "singleton", singleton )
        , ( "insert", insert )
        , ( "remove", remove )
        , ( "isEmpty", isEmpty )
        , ( "member", member )
        , ( "size", size )
        , ( "union", union )
        , ( "intersect", intersect )
        , ( "diff", diff )
        , ( "toList", toList )
        , ( "fromList", fromList )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        , ( "map", map )
        , ( "filter", filter )
        , ( "partition", partition )
        ]


empty : Elm.Syntax.Expression.FunctionImplementation
empty =
    { name = Syntax.fakeNode "Set.empty"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "Set_elm_builtin")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "empty")
                ]
            )
    }


singleton : Elm.Syntax.Expression.FunctionImplementation
singleton =
    { name = Syntax.fakeNode "Set.singleton"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "key") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "Set_elm_builtin")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "singleton"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "key"
                                    )
                                , Syntax.fakeNode Elm.Syntax.Expression.UnitExpr
                                ]
                            )
                        )
                    )
                ]
            )
    }


insert : Elm.Syntax.Expression.FunctionImplementation
insert =
    { name = Syntax.fakeNode "Set.insert"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "key")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "Set_elm_builtin")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "insert"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "key"
                                    )
                                , Syntax.fakeNode Elm.Syntax.Expression.UnitExpr
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "dict"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


remove : Elm.Syntax.Expression.FunctionImplementation
remove =
    { name = Syntax.fakeNode "Set.remove"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "key")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "Set_elm_builtin")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "remove"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "key"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "dict"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


isEmpty : Elm.Syntax.Expression.FunctionImplementation
isEmpty =
    { name = Syntax.fakeNode "Set.isEmpty"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "isEmpty")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                ]
            )
    }


member : Elm.Syntax.Expression.FunctionImplementation
member =
    { name = Syntax.fakeNode "Set.member"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "key")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "member")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "key")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                ]
            )
    }


size : Elm.Syntax.Expression.FunctionImplementation
size =
    { name = Syntax.fakeNode "Set.size"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "size")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                ]
            )
    }


union : Elm.Syntax.Expression.FunctionImplementation
union =
    { name = Syntax.fakeNode "Set.union"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode
                            (Elm.Syntax.Pattern.VarPattern "dict1")
                        ]
                    )
                )
            )
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode
                            (Elm.Syntax.Pattern.VarPattern "dict2")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "Set_elm_builtin")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "union"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "dict1"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "dict2"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


intersect : Elm.Syntax.Expression.FunctionImplementation
intersect =
    { name = Syntax.fakeNode "Set.intersect"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode
                            (Elm.Syntax.Pattern.VarPattern "dict1")
                        ]
                    )
                )
            )
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode
                            (Elm.Syntax.Pattern.VarPattern "dict2")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "Set_elm_builtin")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "intersect"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "dict1"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "dict2"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


diff : Elm.Syntax.Expression.FunctionImplementation
diff =
    { name = Syntax.fakeNode "Set.diff"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode
                            (Elm.Syntax.Pattern.VarPattern "dict1")
                        ]
                    )
                )
            )
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode
                            (Elm.Syntax.Pattern.VarPattern "dict2")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "Set_elm_builtin")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "diff"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "dict1"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "dict2"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


toList : Elm.Syntax.Expression.FunctionImplementation
toList =
    { name = Syntax.fakeNode "Set.toList"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "keys")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                ]
            )
    }


fromList : Elm.Syntax.Expression.FunctionImplementation
fromList =
    { name = Syntax.fakeNode "Set.fromList"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "foldl")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "insert")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "empty")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "list")
                ]
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = Syntax.fakeNode "Set.foldl"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "initialState")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "foldl")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "key")
                                    , Syntax.fakeNode
                                        Elm.Syntax.Pattern.AllPattern
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "state")
                                    ]
                                , expression =
                                    Syntax.fakeNode
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
                                                    "state"
                                                )
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "initialState")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                ]
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = Syntax.fakeNode "Set.foldr"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "initialState")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "foldr")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "key")
                                    , Syntax.fakeNode
                                        Elm.Syntax.Pattern.AllPattern
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "state")
                                    ]
                                , expression =
                                    Syntax.fakeNode
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
                                                    "state"
                                                )
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "initialState")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "dict")
                ]
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = Syntax.fakeNode "Set.map"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "set")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "fromList")
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
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.LambdaExpression
                                                { args =
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "x"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "xs"
                                                        )
                                                    ]
                                                , expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "::"
                                                            Elm.Syntax.Infix.Left
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
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ListExpr [])
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "set"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


filter : Elm.Syntax.Expression.FunctionImplementation
filter =
    { name = Syntax.fakeNode "Set.filter"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "isGood")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "Set_elm_builtin")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "filter"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.LambdaExpression
                                                { args =
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "key"
                                                        )
                                                    , Syntax.fakeNode
                                                        Elm.Syntax.Pattern.AllPattern
                                                    ]
                                                , expression =
                                                    Syntax.fakeNode
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
                                                            ]
                                                        )
                                                }
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "dict"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


partition : Elm.Syntax.Expression.FunctionImplementation
partition =
    { name = Syntax.fakeNode "Set.partition"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "isGood")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ Syntax.fakeNode
                        (Elm.Syntax.Expression.LetDestructuring
                            (Syntax.fakeNode
                                (Elm.Syntax.Pattern.TuplePattern
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "dict1")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern "dict2")
                                    ]
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.Application
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "Dict" ]
                                            "partition"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.LambdaExpression
                                                    { args =
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "key"
                                                            )
                                                        , Syntax.fakeNode
                                                            Elm.Syntax.Pattern.AllPattern
                                                        ]
                                                    , expression =
                                                        Syntax.fakeNode
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
                                                                ]
                                                            )
                                                    }
                                                )
                                            )
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "dict"
                                        )
                                    ]
                                )
                            )
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
                                            "Set_elm_builtin"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "dict1"
                                        )
                                    ]
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.Application
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "Set_elm_builtin"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "dict2"
                                        )
                                    ]
                                )
                            ]
                        )
                }
            )
    }