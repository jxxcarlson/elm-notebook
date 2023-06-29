module Core.Array exposing (append, appendHelpBuilder, appendHelpTree, bitMask, branchFactor, builderFromArray, builderToArray, compressNodes, empty, emptyBuilder, fetchNewTail, filter, foldl, foldr, fromList, fromListHelp, functions, get, getHelp, hoistTree, indexedMap, initialize, initializeHelp, insertTailInTree, isEmpty, length, map, push, repeat, set, setHelp, shiftStep, slice, sliceLeft, sliceRight, sliceTree, tailIndex, toIndexedList, toList, translateIndex, treeFromBuilder, unsafeReplaceTail)

{-| 
@docs functions, branchFactor, shiftStep, bitMask, empty, isEmpty, length, initialize, initializeHelp, repeat, fromList, fromListHelp, get, getHelp, tailIndex, set, setHelp, push, unsafeReplaceTail, insertTailInTree, toList, toIndexedList, foldr, foldl, filter, map, indexedMap, append, appendHelpTree, appendHelpBuilder, slice, translateIndex, sliceRight, fetchNewTail, sliceTree, hoistTree, sliceLeft, emptyBuilder, builderFromArray, builderToArray, treeFromBuilder, compressNodes
-}


import Elm.Syntax.Expression
import Elm.Syntax.Infix
import Elm.Syntax.Pattern
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "branchFactor", branchFactor )
        , ( "shiftStep", shiftStep )
        , ( "bitMask", bitMask )
        , ( "empty", empty )
        , ( "isEmpty", isEmpty )
        , ( "length", length )
        , ( "initialize", initialize )
        , ( "initializeHelp", initializeHelp )
        , ( "repeat", repeat )
        , ( "fromList", fromList )
        , ( "fromListHelp", fromListHelp )
        , ( "get", get )
        , ( "getHelp", getHelp )
        , ( "tailIndex", tailIndex )
        , ( "set", set )
        , ( "setHelp", setHelp )
        , ( "push", push )
        , ( "unsafeReplaceTail", unsafeReplaceTail )
        , ( "insertTailInTree", insertTailInTree )
        , ( "toList", toList )
        , ( "toIndexedList", toIndexedList )
        , ( "foldr", foldr )
        , ( "foldl", foldl )
        , ( "filter", filter )
        , ( "map", map )
        , ( "indexedMap", indexedMap )
        , ( "append", append )
        , ( "appendHelpTree", appendHelpTree )
        , ( "appendHelpBuilder", appendHelpBuilder )
        , ( "slice", slice )
        , ( "translateIndex", translateIndex )
        , ( "sliceRight", sliceRight )
        , ( "fetchNewTail", fetchNewTail )
        , ( "sliceTree", sliceTree )
        , ( "hoistTree", hoistTree )
        , ( "sliceLeft", sliceLeft )
        , ( "emptyBuilder", emptyBuilder )
        , ( "builderFromArray", builderFromArray )
        , ( "builderToArray", builderToArray )
        , ( "treeFromBuilder", treeFromBuilder )
        , ( "compressNodes", compressNodes )
        ]


branchFactor : Elm.Syntax.Expression.FunctionImplementation
branchFactor =
    { name = Syntax.fakeNode "Array.branchFactor"
    , arguments = []
    , expression = Syntax.fakeNode (Elm.Syntax.Expression.Integer 32)
    }


shiftStep : Elm.Syntax.Expression.FunctionImplementation
shiftStep =
    { name = Syntax.fakeNode "Array.shiftStep"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "ceiling")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "logBase"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.Integer 2)
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "toFloat"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "branchFactor"
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


bitMask : Elm.Syntax.Expression.FunctionImplementation
bitMask =
    { name = Syntax.fakeNode "Array.bitMask"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue
                        [ "Bitwise" ]
                        "shiftRightZfBy"
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                "-"
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Integer 32)
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "shiftStep"
                                    )
                                )
                            )
                        )
                    )
                , Syntax.fakeNode (Elm.Syntax.Expression.Hex 0xFFFFFFFF)
                ]
            )
    }


empty : Elm.Syntax.Expression.FunctionImplementation
empty =
    { name = Syntax.fakeNode "Array.empty"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue
                        []
                        "Array_elm_builtin"
                    )
                , Syntax.fakeNode (Elm.Syntax.Expression.Integer 0)
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "shiftStep")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "JsArray" ] "empty"
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [ "JsArray" ] "empty"
                    )
                ]
            )
    }


isEmpty : Elm.Syntax.Expression.FunctionImplementation
isEmpty =
    { name = Syntax.fakeNode "Array.isEmpty"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "len")
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.OperatorApplication
                "=="
                Elm.Syntax.Infix.Left
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "len")
                )
                (Syntax.fakeNode (Elm.Syntax.Expression.Integer 0))
            )
    }


length : Elm.Syntax.Expression.FunctionImplementation
length =
    { name = Syntax.fakeNode "Array.length"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "len")
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "len")
    }


initialize : Elm.Syntax.Expression.FunctionImplementation
initialize =
    { name = Syntax.fakeNode "Array.initialize"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "len")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "fn")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "len")
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "empty")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        Syntax.fakeNode
                                            { name = Syntax.fakeNode "tailLen"
                                            , arguments = []
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "remainderBy"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "branchFactor"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "len"
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
                                            { name = Syntax.fakeNode "tail"
                                            , arguments = []
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "JsArray" ]
                                                                "initialize"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "tailLen"
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
                                                                                "len"
                                                                            )
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "tailLen"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "fn"
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
                                                    "initialFromIndex"
                                            , arguments = []
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "-"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "len"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "tailLen"
                                                                    )
                                                                )
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "branchFactor"
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
                                            "initializeHelp"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "fn"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "initialFromIndex"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "len"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.ListExpr [])
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "tail"
                                        )
                                    ]
                                )
                        }
                    )
                )
            )
    }


initializeHelp : Elm.Syntax.Expression.FunctionImplementation
initializeHelp =
    { name = Syntax.fakeNode "Array.initializeHelp"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "fn")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "fromIndex")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "len")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "nodeList")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tail")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                []
                                "fromIndex"
                            )
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                []
                                "builderToArray"
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "False")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.RecordExpr
                                [ Syntax.fakeNode
                                    ( Syntax.fakeNode "tail"
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "tail"
                                        )
                                    )
                                , Syntax.fakeNode
                                    ( Syntax.fakeNode "nodeList"
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "nodeList"
                                        )
                                    )
                                , Syntax.fakeNode
                                    ( Syntax.fakeNode "nodeListSize"
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "//"
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "len"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "branchFactor"
                                                )
                                            )
                                        )
                                    )
                                ]
                            )
                        ]
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        Syntax.fakeNode
                                            { name = Syntax.fakeNode "leaf"
                                            , arguments = []
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "<|"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "Leaf"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "initialize"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "branchFactor"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "fromIndex"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "fn"
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
                                            "initializeHelp"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "fn"
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
                                                            "fromIndex"
                                                        )
                                                    )
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "branchFactor"
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "len"
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
                                                            "leaf"
                                                        )
                                                    )
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "nodeList"
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "tail"
                                        )
                                    ]
                                )
                        }
                    )
                )
            )
    }


repeat : Elm.Syntax.Expression.FunctionImplementation
repeat =
    { name = Syntax.fakeNode "Array.repeat"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "e")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "initialize")
                , Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "n")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ Syntax.fakeNode
                                        Elm.Syntax.Pattern.AllPattern
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "e"
                                        )
                                }
                            )
                        )
                    )
                ]
            )
    }


fromList : Elm.Syntax.Expression.FunctionImplementation
fromList =
    { name = Syntax.fakeNode "Array.fromList"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue [] "list")
                , cases =
                    [ ( Syntax.fakeNode (Elm.Syntax.Pattern.ListPattern [])
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "empty")
                      )
                    , ( Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                      , Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "fromListHelp"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "list"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ListExpr [])
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.Integer 0)
                                ]
                            )
                      )
                    ]
                }
            )
    }


fromListHelp : Elm.Syntax.Expression.FunctionImplementation
fromListHelp =
    { name = Syntax.fakeNode "Array.fromListHelp"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "list")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "nodeList")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "nodeListSize")
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
                                        (Elm.Syntax.Pattern.VarPattern "jsArray"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern
                                            "remainingItems"
                                        )
                                    ]
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.Application
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "JsArray" ]
                                            "initializeFromList"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "branchFactor"
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
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.IfBlock
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "length"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "jsArray"
                                                )
                                            ]
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "branchFactor"
                                        )
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.Application
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "builderToArray"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "True"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.RecordExpr
                                            [ Syntax.fakeNode
                                                ( Syntax.fakeNode "tail"
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "jsArray"
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                ( Syntax.fakeNode "nodeList"
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nodeList"
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                ( Syntax.fakeNode "nodeListSize"
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nodeListSize"
                                                    )
                                                )
                                            ]
                                        )
                                    ]
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.Application
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "fromListHelp"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "remainingItems"
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
                                                                    "Leaf"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "jsArray"
                                                                )
                                                            ]
                                                        )
                                                    )
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "nodeList"
                                                        )
                                                    )
                                                )
                                            )
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
                                                            "nodeListSize"
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
                }
            )
    }


get : Elm.Syntax.Expression.FunctionImplementation
get =
    { name = Syntax.fakeNode "Array.get"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "index")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "len")
                        , Syntax.fakeNode
                            (Elm.Syntax.Pattern.VarPattern "startShift")
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tail")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        ">="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                "||"
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "<"
                                        Elm.Syntax.Infix.Left
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "index"
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Integer 0)
                                        )
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "index"
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "len")
                        )
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "Nothing")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.IfBlock
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                ">="
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "index"
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tailIndex"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "len"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                "<|"
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Just"
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeGet"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "bitMask"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "index"
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                "<|"
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Just"
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "getHelp"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "startShift"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "index"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tree"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                    )
                )
            )
    }


getHelp : Elm.Syntax.Expression.FunctionImplementation
getHelp =
    { name = Syntax.fakeNode "Array.getHelp"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "shift")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "index")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
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
                                    { name = Syntax.fakeNode "pos"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<|"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "bitMask"
                                                            )
                                                        ]
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "shiftRightZfBy"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "shift"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "index"
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
                        (Elm.Syntax.Expression.CaseExpression
                            { expression =
                                Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeGet"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "pos"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tree"
                                            )
                                        ]
                                    )
                            , cases =
                                [ ( Syntax.fakeNode
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = []
                                            , name = "SubTree"
                                            }
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "subTree"
                                                )
                                            ]
                                        )
                                  , Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "getHelp"
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
                                                                    "shift"
                                                                )
                                                            )
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "shiftStep"
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "index"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "subTree"
                                                )
                                            ]
                                        )
                                  )
                                , ( Syntax.fakeNode
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = [], name = "Leaf" }
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "values"
                                                )
                                            ]
                                        )
                                  , Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "unsafeGet"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.Application
                                                            [ Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    [ "Bitwise"
                                                                    ]
                                                                    "and"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "bitMask"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "index"
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "values"
                                                )
                                            ]
                                        )
                                  )
                                ]
                            }
                        )
                }
            )
    }


tailIndex : Elm.Syntax.Expression.FunctionImplementation
tailIndex =
    { name = Syntax.fakeNode "Array.tailIndex"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "len") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.OperatorApplication
                "|>"
                Elm.Syntax.Infix.Left
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "|>"
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "len")
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Bitwise" ]
                                        "shiftRightZfBy"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.Integer 5)
                                ]
                            )
                        )
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                [ "Bitwise" ]
                                "shiftLeftBy"
                            )
                        , Syntax.fakeNode (Elm.Syntax.Expression.Integer 5)
                        ]
                    )
                )
            )
    }


set : Elm.Syntax.Expression.FunctionImplementation
set =
    { name = Syntax.fakeNode "Array.set"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "index")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "value")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.AsPattern
                        (Syntax.fakeNode
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "len"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "startShift"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tree"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode "array")
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        ">="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                "||"
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "<"
                                        Elm.Syntax.Infix.Left
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "index"
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Integer 0)
                                        )
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "index"
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "len")
                        )
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "array")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.IfBlock
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                ">="
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "index"
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tailIndex"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "len"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                "<|"
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "Array_elm_builtin"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "len"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "startShift"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tree"
                                            )
                                        ]
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeSet"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "bitMask"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "index"
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "value"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "Array_elm_builtin"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "len"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "startShift"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "setHelp"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "startShift"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "index"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "value"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "tree"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "tail"
                                    )
                                ]
                            )
                        )
                    )
                )
            )
    }


setHelp : Elm.Syntax.Expression.FunctionImplementation
setHelp =
    { name = Syntax.fakeNode "Array.setHelp"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "shift")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "index")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "value")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
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
                                    { name = Syntax.fakeNode "pos"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<|"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "bitMask"
                                                            )
                                                        ]
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "shiftRightZfBy"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "shift"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "index"
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
                        (Elm.Syntax.Expression.CaseExpression
                            { expression =
                                Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeGet"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "pos"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tree"
                                            )
                                        ]
                                    )
                            , cases =
                                [ ( Syntax.fakeNode
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = []
                                            , name = "SubTree"
                                            }
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "subTree"
                                                )
                                            ]
                                        )
                                  , Syntax.fakeNode
                                        (Elm.Syntax.Expression.LetExpression
                                            { declarations =
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.LetFunction
                                                        { documentation =
                                                            Nothing
                                                        , signature = Nothing
                                                        , declaration =
                                                            Syntax.fakeNode
                                                                { name =
                                                                    Syntax.fakeNode
                                                                        "newSub"
                                                                , arguments = []
                                                                , expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "setHelp"
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
                                                                                                    "shift"
                                                                                                )
                                                                                            )
                                                                                            (Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    []
                                                                                                    "shiftStep"
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "index"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "value"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "subTree"
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
                                                                [ "JsArray" ]
                                                                "unsafeSet"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "pos"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "SubTree"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "newSub"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "tree"
                                                            )
                                                        ]
                                                    )
                                            }
                                        )
                                  )
                                , ( Syntax.fakeNode
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = [], name = "Leaf" }
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "values"
                                                )
                                            ]
                                        )
                                  , Syntax.fakeNode
                                        (Elm.Syntax.Expression.LetExpression
                                            { declarations =
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.LetFunction
                                                        { documentation =
                                                            Nothing
                                                        , signature = Nothing
                                                        , declaration =
                                                            Syntax.fakeNode
                                                                { name =
                                                                    Syntax.fakeNode
                                                                        "newLeaf"
                                                                , arguments = []
                                                                , expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    [ "JsArray"
                                                                                    ]
                                                                                    "unsafeSet"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                    (Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.Application
                                                                                            [ Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    [ "Bitwise"
                                                                                                    ]
                                                                                                    "and"
                                                                                                )
                                                                                            , Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    []
                                                                                                    "bitMask"
                                                                                                )
                                                                                            , Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    []
                                                                                                    "index"
                                                                                                )
                                                                                            ]
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "value"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "values"
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
                                                                [ "JsArray" ]
                                                                "unsafeSet"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "pos"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "Leaf"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "newLeaf"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "tree"
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
            )
    }


push : Elm.Syntax.Expression.FunctionImplementation
push =
    { name = Syntax.fakeNode "Array.push"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "a")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.AsPattern
                        (Syntax.fakeNode
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        , Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        , Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode "array")
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
                        "unsafeReplaceTail"
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "JsArray" ]
                                        "push"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "a"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "tail"
                                    )
                                ]
                            )
                        )
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "array")
                ]
            )
    }


unsafeReplaceTail : Elm.Syntax.Expression.FunctionImplementation
unsafeReplaceTail =
    { name = Syntax.fakeNode "Array.unsafeReplaceTail"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "newTail")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "len")
                        , Syntax.fakeNode
                            (Elm.Syntax.Pattern.VarPattern "startShift")
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tail")
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
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "originalTailLen"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "length"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "tail"
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
                                    { name = Syntax.fakeNode "newTailLen"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "length"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "newTail"
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
                                    { name = Syntax.fakeNode "newArrayLen"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "+"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "len"
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "-"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "newTailLen"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "originalTailLen"
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.IfBlock
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "=="
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "newTailLen"
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "branchFactor"
                                        )
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.LetExpression
                                    { declarations =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.LetFunction
                                                { documentation = Nothing
                                                , signature = Nothing
                                                , declaration =
                                                    Syntax.fakeNode
                                                        { name =
                                                            Syntax.fakeNode
                                                                "overflow"
                                                        , arguments = []
                                                        , expression =
                                                            Syntax.fakeNode
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    ">"
                                                                    Elm.Syntax.Infix.Left
                                                                    (Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    [ "Bitwise"
                                                                                    ]
                                                                                    "shiftRightZfBy"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "shiftStep"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "newArrayLen"
                                                                                )
                                                                            ]
                                                                        )
                                                                    )
                                                                    (Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    [ "Bitwise"
                                                                                    ]
                                                                                    "shiftLeftBy"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "startShift"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.Integer
                                                                                    1
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
                                            (Elm.Syntax.Expression.IfBlock
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "overflow"
                                                    )
                                                )
                                                (Syntax.fakeNode
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
                                                                                    "newShift"
                                                                            , arguments =
                                                                                []
                                                                            , expression =
                                                                                Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "+"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "startShift"
                                                                                            )
                                                                                        )
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "shiftStep"
                                                                                            )
                                                                                        )
                                                                                    )
                                                                            }
                                                                    }
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.LetFunction
                                                                    { documentation =
                                                                        Nothing
                                                                    , signature =
                                                                        Nothing
                                                                    , declaration =
                                                                        Syntax.fakeNode
                                                                            { name =
                                                                                Syntax.fakeNode
                                                                                    "newTree"
                                                                            , arguments =
                                                                                []
                                                                            , expression =
                                                                                Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "|>"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        [ "JsArray"
                                                                                                        ]
                                                                                                        "singleton"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "SubTree"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "tree"
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
                                                                                                        "insertTailInTree"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "newShift"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "len"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "newTail"
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
                                                                            "Array_elm_builtin"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "newArrayLen"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "newShift"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "newTree"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            [ "JsArray"
                                                                            ]
                                                                            "empty"
                                                                        )
                                                                    ]
                                                                )
                                                        }
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "Array_elm_builtin"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "newArrayLen"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "startShift"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "insertTailInTree"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "startShift"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "len"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "newTail"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "tree"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "JsArray" ]
                                                                "empty"
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                    }
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.Application
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "Array_elm_builtin"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "newArrayLen"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "startShift"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "tree"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "newTail"
                                        )
                                    ]
                                )
                            )
                        )
                }
            )
    }


insertTailInTree : Elm.Syntax.Expression.FunctionImplementation
insertTailInTree =
    { name = Syntax.fakeNode "Array.insertTailInTree"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "shift")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "index")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tail")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
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
                                    { name = Syntax.fakeNode "pos"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<|"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "bitMask"
                                                            )
                                                        ]
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "shiftRightZfBy"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "shift"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "index"
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
                        (Elm.Syntax.Expression.IfBlock
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    ">="
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "pos"
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "length"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "tree"
                                                )
                                            ]
                                        )
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.IfBlock
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "=="
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "shift"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Integer 5
                                                )
                                            )
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "push"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.Application
                                                            [ Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "Leaf"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "tail"
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "tree"
                                                )
                                            ]
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.LetExpression
                                            { declarations =
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.LetFunction
                                                        { documentation =
                                                            Nothing
                                                        , signature = Nothing
                                                        , declaration =
                                                            Syntax.fakeNode
                                                                { name =
                                                                    Syntax.fakeNode
                                                                        "newSub"
                                                                , arguments = []
                                                                , expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                            "|>"
                                                                            Elm.Syntax.Infix.Left
                                                                            (Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                                    "|>"
                                                                                    Elm.Syntax.Infix.Left
                                                                                    (Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                            [ "JsArray"
                                                                                            ]
                                                                                            "empty"
                                                                                        )
                                                                                    )
                                                                                    (Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.Application
                                                                                            [ Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    []
                                                                                                    "insertTailInTree"
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
                                                                                                                    "shift"
                                                                                                                )
                                                                                                            )
                                                                                                            (Syntax.fakeNode
                                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                    []
                                                                                                                    "shiftStep"
                                                                                                                )
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                            , Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    []
                                                                                                    "index"
                                                                                                )
                                                                                            , Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    []
                                                                                                    "tail"
                                                                                                )
                                                                                            ]
                                                                                        )
                                                                                    )
                                                                                )
                                                                            )
                                                                            (Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "SubTree"
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
                                                                [ "JsArray" ]
                                                                "push"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "newSub"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "tree"
                                                            )
                                                        ]
                                                    )
                                            }
                                        )
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.LetExpression
                                    { declarations =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.LetFunction
                                                { documentation = Nothing
                                                , signature = Nothing
                                                , declaration =
                                                    Syntax.fakeNode
                                                        { name =
                                                            Syntax.fakeNode
                                                                "value"
                                                        , arguments = []
                                                        , expression =
                                                            Syntax.fakeNode
                                                                (Elm.Syntax.Expression.Application
                                                                    [ Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            [ "JsArray"
                                                                            ]
                                                                            "unsafeGet"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "pos"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "tree"
                                                                        )
                                                                    ]
                                                                )
                                                        }
                                                }
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "value"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
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
                                                                                            "newSub"
                                                                                    , arguments =
                                                                                        []
                                                                                    , expression =
                                                                                        Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                "|>"
                                                                                                Elm.Syntax.Infix.Left
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                                        "|>"
                                                                                                        Elm.Syntax.Infix.Left
                                                                                                        (Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "subTree"
                                                                                                            )
                                                                                                        )
                                                                                                        (Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "insertTailInTree"
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
                                                                                                                                        "shift"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "shiftStep"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "index"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "tail"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "SubTree"
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
                                                                                    [ "JsArray"
                                                                                    ]
                                                                                    "unsafeSet"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "pos"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "newSub"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "tree"
                                                                                )
                                                                            ]
                                                                        )
                                                                }
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Leaf"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
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
                                                                                            "newSub"
                                                                                    , arguments =
                                                                                        []
                                                                                    , expression =
                                                                                        Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                "|>"
                                                                                                Elm.Syntax.Infix.Left
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                                        "|>"
                                                                                                        Elm.Syntax.Infix.Left
                                                                                                        (Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        [ "JsArray"
                                                                                                                        ]
                                                                                                                        "singleton"
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
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "insertTailInTree"
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
                                                                                                                                        "shift"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (Syntax.fakeNode
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        []
                                                                                                                                        "shiftStep"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "index"
                                                                                                                    )
                                                                                                                , Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        []
                                                                                                                        "tail"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "SubTree"
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
                                                                                    [ "JsArray"
                                                                                    ]
                                                                                    "unsafeSet"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "pos"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "newSub"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "tree"
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
                                )
                            )
                        )
                }
            )
    }


toList : Elm.Syntax.Expression.FunctionImplementation
toList =
    { name = Syntax.fakeNode "Array.toList"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "array") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldr")
                , Syntax.fakeNode (Elm.Syntax.Expression.PrefixOperator "::")
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "array")
                ]
            )
    }


toIndexedList : Elm.Syntax.Expression.FunctionImplementation
toIndexedList =
    { name = Syntax.fakeNode "Array.toIndexedList"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.AsPattern
                        (Syntax.fakeNode
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "len"
                                            )
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
                        (Syntax.fakeNode "array")
                    )
                )
            )
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
                                    { name = Syntax.fakeNode "helper"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "entry"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "index"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "list"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.TupledExpression
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "index"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Integer
                                                                1
                                                            )
                                                        )
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "::"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.TupledExpression
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "index"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "entry"
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
                                    [ "Tuple" ]
                                    "second"
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
                                                    "helper"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.TupledExpression
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "-"
                                                            Elm.Syntax.Infix.Left
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "len"
                                                                )
                                                            )
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.Integer
                                                                    1
                                                                )
                                                            )
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.ListExpr
                                                            []
                                                        )
                                                    ]
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "array"
                                                )
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                }
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = Syntax.fakeNode "Array.foldr"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "baseCase")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tail")
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
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "helper"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "node"
                                            )
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
                                                            "node"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldr"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "helper"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "acc"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Leaf"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "values"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
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
                                                                        "values"
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
                                    [ "JsArray" ]
                                    "foldr"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "helper"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
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
                                                    "baseCase"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "tail"
                                                )
                                            ]
                                        )
                                    )
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "tree"
                                )
                            ]
                        )
                }
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = Syntax.fakeNode "Array.foldl"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "baseCase")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tail")
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
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "helper"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "node"
                                            )
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
                                                            "node"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldl"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "helper"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "acc"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Leaf"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "values"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
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
                                                                        "values"
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
                                    [ "JsArray" ]
                                    "foldl"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "func"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "foldl"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "helper"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "baseCase"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "tree"
                                                )
                                            ]
                                        )
                                    )
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "tail"
                                )
                            ]
                        )
                }
            )
    }


filter : Elm.Syntax.Expression.FunctionImplementation
filter =
    { name = Syntax.fakeNode "Array.filter"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "isGood")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "array")
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
                                        "foldr"
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
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "::"
                                                                    Elm.Syntax.Infix.Left
                                                                    (Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "x"
                                                                        )
                                                                    )
                                                                    (Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "xs"
                                                                        )
                                                                    )
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
                                        "array"
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
    { name = Syntax.fakeNode "Array.map"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "len")
                        , Syntax.fakeNode
                            (Elm.Syntax.Pattern.VarPattern "startShift")
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tail")
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
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "helper"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "node"
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "node"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "<|"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "SubTree"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "map"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "helper"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "subTree"
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
                                                                , name = "Leaf"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "values"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "<|"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Leaf"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
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
                                                                                "values"
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
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.Application
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "Array_elm_builtin"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "len")
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "startShift"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "map"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "helper"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "tree"
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
                                                    [ "JsArray" ]
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
                                                    "tail"
                                                )
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                }
            )
    }


indexedMap : Elm.Syntax.Expression.FunctionImplementation
indexedMap =
    { name = Syntax.fakeNode "Array.indexedMap"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "func")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "len")
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tail")
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
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "helper"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "node"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "builder"
                                            )
                                        ]
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "node"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldl"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "helper"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "builder"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Leaf"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "leaf"
                                                                    )
                                                                ]
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
                                                                                            "offset"
                                                                                    , arguments =
                                                                                        []
                                                                                    , expression =
                                                                                        Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                "*"
                                                                                                Elm.Syntax.Infix.Left
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.RecordAccess
                                                                                                        (Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "builder"
                                                                                                            )
                                                                                                        )
                                                                                                        (Syntax.fakeNode
                                                                                                            "nodeListSize"
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "branchFactor"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                    }
                                                                            }
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.LetFunction
                                                                            { documentation =
                                                                                Nothing
                                                                            , signature =
                                                                                Nothing
                                                                            , declaration =
                                                                                Syntax.fakeNode
                                                                                    { name =
                                                                                        Syntax.fakeNode
                                                                                            "mappedLeaf"
                                                                                    , arguments =
                                                                                        []
                                                                                    , expression =
                                                                                        Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                "<|"
                                                                                                Elm.Syntax.Infix.Left
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "Leaf"
                                                                                                    )
                                                                                                )
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                        [ Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                [ "JsArray"
                                                                                                                ]
                                                                                                                "indexedMap"
                                                                                                            )
                                                                                                        , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "func"
                                                                                                            )
                                                                                                        , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "offset"
                                                                                                            )
                                                                                                        , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "leaf"
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
                                                                        (Elm.Syntax.Expression.RecordExpr
                                                                            [ Syntax.fakeNode
                                                                                ( Syntax.fakeNode
                                                                                    "tail"
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.RecordAccess
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "builder"
                                                                                            )
                                                                                        )
                                                                                        (Syntax.fakeNode
                                                                                            "tail"
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                ( Syntax.fakeNode
                                                                                    "nodeList"
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "::"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "mappedLeaf"
                                                                                            )
                                                                                        )
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.RecordAccess
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "builder"
                                                                                                    )
                                                                                                )
                                                                                                (Syntax.fakeNode
                                                                                                    "nodeList"
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                ( Syntax.fakeNode
                                                                                    "nodeListSize"
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "+"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.RecordAccess
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "builder"
                                                                                                    )
                                                                                                )
                                                                                                (Syntax.fakeNode
                                                                                                    "nodeListSize"
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Integer
                                                                                                1
                                                                                            )
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
                            }
                        )
                    , Syntax.fakeNode
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "initialBuilder"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.RecordExpr
                                                [ Syntax.fakeNode
                                                    ( Syntax.fakeNode "tail"
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.Application
                                                            [ Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    [ "JsArray"
                                                                    ]
                                                                    "indexedMap"
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
                                                                                    "tailIndex"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "len"
                                                                                )
                                                                            ]
                                                                        )
                                                                    )
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "tail"
                                                                )
                                                            ]
                                                        )
                                                    )
                                                , Syntax.fakeNode
                                                    ( Syntax.fakeNode "nodeList"
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.ListExpr
                                                            []
                                                        )
                                                    )
                                                , Syntax.fakeNode
                                                    ( Syntax.fakeNode
                                                        "nodeListSize"
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.Integer
                                                            0
                                                        )
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
                                    "builderToArray"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "True"
                                )
                            , Syntax.fakeNode
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "foldl"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "helper"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "initialBuilder"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "tree"
                                                )
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                }
            )
    }


append : Elm.Syntax.Expression.FunctionImplementation
append =
    { name = Syntax.fakeNode "Array.append"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.AsPattern
                        (Syntax.fakeNode
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        , Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        , Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "aTail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode "a")
                    )
                )
            )
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "bLen")
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode
                            (Elm.Syntax.Pattern.VarPattern "bTree")
                        , Syntax.fakeNode
                            (Elm.Syntax.Pattern.VarPattern "bTail")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "bLen")
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "*"
                                        Elm.Syntax.Infix.Left
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "branchFactor"
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.Integer 4)
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        Syntax.fakeNode
                                            { name =
                                                Syntax.fakeNode "foldHelper"
                                            , arguments =
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "node"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "array"
                                                    )
                                                ]
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.CaseExpression
                                                        { expression =
                                                            Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "node"
                                                                )
                                                        , cases =
                                                            [ ( Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "SubTree"
                                                                        }
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "tree"
                                                                            )
                                                                        ]
                                                                    )
                                                              , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "foldl"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "foldHelper"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "array"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "tree"
                                                                            )
                                                                        ]
                                                                    )
                                                              )
                                                            , ( Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Leaf"
                                                                        }
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "leaf"
                                                                            )
                                                                        ]
                                                                    )
                                                              , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "appendHelpTree"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "leaf"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "array"
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
                                (Elm.Syntax.Expression.OperatorApplication
                                    "|>"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "foldl"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "foldHelper"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "a"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "bTree"
                                                )
                                            ]
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "appendHelpTree"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "bTail"
                                                )
                                            ]
                                        )
                                    )
                                )
                        }
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        Syntax.fakeNode
                                            { name =
                                                Syntax.fakeNode "foldHelper"
                                            , arguments =
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "node"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "builder"
                                                    )
                                                ]
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.CaseExpression
                                                        { expression =
                                                            Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "node"
                                                                )
                                                        , cases =
                                                            [ ( Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "SubTree"
                                                                        }
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "tree"
                                                                            )
                                                                        ]
                                                                    )
                                                              , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "foldl"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "foldHelper"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "builder"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "tree"
                                                                            )
                                                                        ]
                                                                    )
                                                              )
                                                            , ( Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Leaf"
                                                                        }
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "leaf"
                                                                            )
                                                                        ]
                                                                    )
                                                              , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "appendHelpBuilder"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "leaf"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "builder"
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
                                (Elm.Syntax.Expression.OperatorApplication
                                    "|>"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "|>"
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Application
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            [ "JsArray" ]
                                                            "foldl"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "foldHelper"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.Application
                                                                    [ Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "builderFromArray"
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
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "bTree"
                                                        )
                                                    ]
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Application
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "appendHelpBuilder"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "bTail"
                                                        )
                                                    ]
                                                )
                                            )
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "builderToArray"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "True"
                                                )
                                            ]
                                        )
                                    )
                                )
                        }
                    )
                )
            )
    }


appendHelpTree : Elm.Syntax.Expression.FunctionImplementation
appendHelpTree =
    { name = Syntax.fakeNode "Array.appendHelpTree"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "toAppend")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.AsPattern
                        (Syntax.fakeNode
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "len"
                                            )
                                        , Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tree"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode "array")
                    )
                )
            )
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
                                    { name = Syntax.fakeNode "appended"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "appendN"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "branchFactor"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "tail"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "toAppend"
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
                                    { name = Syntax.fakeNode "itemsToAppend"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "length"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "toAppend"
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
                                    { name = Syntax.fakeNode "notAppended"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "-"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "branchFactor"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "length"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "tail"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "itemsToAppend"
                                                    )
                                                )
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
                                    { name = Syntax.fakeNode "newArray"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "unsafeReplaceTail"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "appended"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "array"
                                                    )
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.IfBlock
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "notAppended"
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Integer 0)
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.LetExpression
                                    { declarations =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.LetFunction
                                                { documentation = Nothing
                                                , signature = Nothing
                                                , declaration =
                                                    Syntax.fakeNode
                                                        { name =
                                                            Syntax.fakeNode
                                                                "nextTail"
                                                        , arguments = []
                                                        , expression =
                                                            Syntax.fakeNode
                                                                (Elm.Syntax.Expression.Application
                                                                    [ Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            [ "JsArray"
                                                                            ]
                                                                            "slice"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "notAppended"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "itemsToAppend"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "toAppend"
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
                                                        "unsafeReplaceTail"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nextTail"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "newArray"
                                                    )
                                                ]
                                            )
                                    }
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "newArray"
                                )
                            )
                        )
                }
            )
    }


appendHelpBuilder : Elm.Syntax.Expression.FunctionImplementation
appendHelpBuilder =
    { name = Syntax.fakeNode "Array.appendHelpBuilder"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tail")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "builder")
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
                                    { name = Syntax.fakeNode "appended"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "appendN"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "branchFactor"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.RecordAccess
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "builder"
                                                            )
                                                        )
                                                        (Syntax.fakeNode "tail")
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "tail"
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
                                    { name = Syntax.fakeNode "tailLen"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "length"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "tail"
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
                                    { name = Syntax.fakeNode "notAppended"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "-"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "branchFactor"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "length"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.RecordAccess
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "builder"
                                                                                    )
                                                                                )
                                                                                (Syntax.fakeNode
                                                                                    "tail"
                                                                                )
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "tailLen"
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.IfBlock
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "notAppended"
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Integer 0)
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.RecordExpr
                                    [ Syntax.fakeNode
                                        ( Syntax.fakeNode "tail"
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "slice"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "notAppended"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "tailLen"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "tail"
                                                    )
                                                ]
                                            )
                                        )
                                    , Syntax.fakeNode
                                        ( Syntax.fakeNode "nodeList"
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "::"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "Leaf"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "appended"
                                                            )
                                                        ]
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.RecordAccess
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "builder"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            "nodeList"
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    , Syntax.fakeNode
                                        ( Syntax.fakeNode "nodeListSize"
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "+"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.RecordAccess
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "builder"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            "nodeListSize"
                                                        )
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Integer
                                                        1
                                                    )
                                                )
                                            )
                                        )
                                    ]
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.IfBlock
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "=="
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "notAppended"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Integer 0
                                                )
                                            )
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.RecordExpr
                                            [ Syntax.fakeNode
                                                ( Syntax.fakeNode "tail"
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "empty"
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                ( Syntax.fakeNode "nodeList"
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "::"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "Leaf"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "appended"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.RecordAccess
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "builder"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    "nodeList"
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                ( Syntax.fakeNode "nodeListSize"
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "+"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.RecordAccess
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "builder"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    "nodeListSize"
                                                                )
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Integer
                                                                1
                                                            )
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.RecordExpr
                                            [ Syntax.fakeNode
                                                ( Syntax.fakeNode "tail"
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "appended"
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                ( Syntax.fakeNode "nodeList"
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.RecordAccess
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "builder"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            "nodeList"
                                                        )
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                ( Syntax.fakeNode "nodeListSize"
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.RecordAccess
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "builder"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            "nodeListSize"
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                    )
                                )
                            )
                        )
                }
            )
    }


slice : Elm.Syntax.Expression.FunctionImplementation
slice =
    { name = Syntax.fakeNode "Array.slice"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "from")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "to")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "array")
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
                                    { name = Syntax.fakeNode "correctFrom"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "translateIndex"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "from"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "array"
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
                                    { name = Syntax.fakeNode "correctTo"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "translateIndex"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "to"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "array"
                                                    )
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
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
                                            "correctFrom"
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "correctTo"
                                        )
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue
                                    []
                                    "empty"
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "|>"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "|>"
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "array"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Application
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "sliceRight"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "correctTo"
                                                        )
                                                    ]
                                                )
                                            )
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "sliceLeft"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "correctFrom"
                                                )
                                            ]
                                        )
                                    )
                                )
                            )
                        )
                }
            )
    }


translateIndex : Elm.Syntax.Expression.FunctionImplementation
translateIndex =
    { name = Syntax.fakeNode "Array.translateIndex"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "index")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "len")
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
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
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "posIndex"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.IfBlock
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "<"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "index"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Integer
                                                                0
                                                            )
                                                        )
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "+"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "len"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "index"
                                                            )
                                                        )
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "index"
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.IfBlock
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "posIndex"
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Integer 0)
                                    )
                                )
                            )
                            (Syntax.fakeNode (Elm.Syntax.Expression.Integer 0))
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.IfBlock
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            ">"
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "posIndex"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "len"
                                                )
                                            )
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "len"
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "posIndex"
                                        )
                                    )
                                )
                            )
                        )
                }
            )
    }


sliceRight : Elm.Syntax.Expression.FunctionImplementation
sliceRight =
    { name = Syntax.fakeNode "Array.sliceRight"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "end")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.AsPattern
                        (Syntax.fakeNode
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "len"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "startShift"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tree"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode "array")
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "=="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "end")
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "len")
                        )
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "array")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.IfBlock
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                ">="
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "end"
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tailIndex"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "len"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                "<|"
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "Array_elm_builtin"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "end"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "startShift"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tree"
                                            )
                                        ]
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "slice"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.Integer 0)
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "bitMask"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "end"
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                Syntax.fakeNode
                                                    { name =
                                                        Syntax.fakeNode "endIdx"
                                                    , arguments = []
                                                    , expression =
                                                        Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "tailIndex"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "end"
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
                                                        Syntax.fakeNode "depth"
                                                    , arguments = []
                                                    , expression =
                                                        Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "|>"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "|>"
                                                                        Elm.Syntax.Infix.Left
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                "|>"
                                                                                Elm.Syntax.Infix.Left
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "|>"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                (Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                                        "-"
                                                                                                        Elm.Syntax.Infix.Left
                                                                                                        (Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "endIdx"
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
                                                                                        )
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "max"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.Integer
                                                                                                        1
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "toFloat"
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "logBase"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "toFloat"
                                                                                                    )
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        []
                                                                                                        "branchFactor"
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
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "floor"
                                                                    )
                                                                )
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
                                                            "newShift"
                                                    , arguments = []
                                                    , expression =
                                                        Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "*"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "<|"
                                                                        Elm.Syntax.Infix.Left
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "max"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.Integer
                                                                                        5
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "depth"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "shiftStep"
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
                                                    "Array_elm_builtin"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "end"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "newShift"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "|>"
                                                            Elm.Syntax.Infix.Left
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "|>"
                                                                    Elm.Syntax.Infix.Left
                                                                    (Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "tree"
                                                                        )
                                                                    )
                                                                    (Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "sliceTree"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "startShift"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "endIdx"
                                                                                )
                                                                            ]
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.Application
                                                                    [ Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "hoistTree"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "startShift"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "newShift"
                                                                        )
                                                                    ]
                                                                )
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
                                                                    "fetchNewTail"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "startShift"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "end"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "endIdx"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "tree"
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
                )
            )
    }


fetchNewTail : Elm.Syntax.Expression.FunctionImplementation
fetchNewTail =
    { name = Syntax.fakeNode "Array.fetchNewTail"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "shift")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "end")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "treeEnd")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
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
                                    { name = Syntax.fakeNode "pos"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<|"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "bitMask"
                                                            )
                                                        ]
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "shiftRightZfBy"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "shift"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "treeEnd"
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
                        (Elm.Syntax.Expression.CaseExpression
                            { expression =
                                Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeGet"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "pos"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tree"
                                            )
                                        ]
                                    )
                            , cases =
                                [ ( Syntax.fakeNode
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = []
                                            , name = "SubTree"
                                            }
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "sub"
                                                )
                                            ]
                                        )
                                  , Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "fetchNewTail"
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
                                                                    "shift"
                                                                )
                                                            )
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "shiftStep"
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "end"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "treeEnd"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "sub"
                                                )
                                            ]
                                        )
                                  )
                                , ( Syntax.fakeNode
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = [], name = "Leaf" }
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "values"
                                                )
                                            ]
                                        )
                                  , Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "slice"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.Integer 0
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.Application
                                                            [ Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    [ "Bitwise"
                                                                    ]
                                                                    "and"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "bitMask"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "end"
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "values"
                                                )
                                            ]
                                        )
                                  )
                                ]
                            }
                        )
                }
            )
    }


sliceTree : Elm.Syntax.Expression.FunctionImplementation
sliceTree =
    { name = Syntax.fakeNode "Array.sliceTree"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "shift")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "endIdx")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
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
                                    { name = Syntax.fakeNode "lastPos"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<|"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "bitMask"
                                                            )
                                                        ]
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "shiftRightZfBy"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "shift"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "endIdx"
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
                        (Elm.Syntax.Expression.CaseExpression
                            { expression =
                                Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeGet"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "lastPos"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tree"
                                            )
                                        ]
                                    )
                            , cases =
                                [ ( Syntax.fakeNode
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = []
                                            , name = "SubTree"
                                            }
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "sub"
                                                )
                                            ]
                                        )
                                  , Syntax.fakeNode
                                        (Elm.Syntax.Expression.LetExpression
                                            { declarations =
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.LetFunction
                                                        { documentation =
                                                            Nothing
                                                        , signature = Nothing
                                                        , declaration =
                                                            Syntax.fakeNode
                                                                { name =
                                                                    Syntax.fakeNode
                                                                        "newSub"
                                                                , arguments = []
                                                                , expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "sliceTree"
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
                                                                                                    "shift"
                                                                                                )
                                                                                            )
                                                                                            (Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    []
                                                                                                    "shiftStep"
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "endIdx"
                                                                                )
                                                                            , Syntax.fakeNode
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    []
                                                                                    "sub"
                                                                                )
                                                                            ]
                                                                        )
                                                                }
                                                        }
                                                    )
                                                ]
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.IfBlock
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "=="
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "length"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "newSub"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Integer
                                                                        0
                                                                    )
                                                                )
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "slice"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Integer
                                                                        0
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "lastPos"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "tree"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "|>"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "|>"
                                                                        Elm.Syntax.Infix.Left
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "tree"
                                                                            )
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "JsArray"
                                                                                        ]
                                                                                        "slice"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.Integer
                                                                                        0
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
                                                                                                        "lastPos"
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
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "unsafeSet"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "lastPos"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "SubTree"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "newSub"
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
                                                    )
                                            }
                                        )
                                  )
                                , ( Syntax.fakeNode
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = [], name = "Leaf" }
                                            [ Syntax.fakeNode
                                                Elm.Syntax.Pattern.AllPattern
                                            ]
                                        )
                                  , Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "slice"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.Integer 0
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "lastPos"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "tree"
                                                )
                                            ]
                                        )
                                  )
                                ]
                            }
                        )
                }
            )
    }


hoistTree : Elm.Syntax.Expression.FunctionImplementation
hoistTree =
    { name = Syntax.fakeNode "Array.hoistTree"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "oldShift")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "newShift")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "=="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                "||"
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "<="
                                        Elm.Syntax.Infix.Left
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "oldShift"
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "newShift"
                                            )
                                        )
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "length"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tree"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "tree")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.CaseExpression
                        { expression =
                            Syntax.fakeNode
                                (Elm.Syntax.Expression.Application
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "JsArray" ]
                                            "unsafeGet"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.Integer 0)
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "tree"
                                        )
                                    ]
                                )
                        , cases =
                            [ ( Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "SubTree" }
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "sub"
                                            )
                                        ]
                                    )
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "hoistTree"
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
                                                                "oldShift"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "shiftStep"
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "newShift"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "sub"
                                            )
                                        ]
                                    )
                              )
                            , ( Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "Leaf" }
                                        [ Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        ]
                                    )
                              , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "tree"
                                    )
                              )
                            ]
                        }
                    )
                )
            )
    }


sliceLeft : Elm.Syntax.Expression.FunctionImplementation
sliceLeft =
    { name = Syntax.fakeNode "Array.sliceLeft"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "from")
        , Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.AsPattern
                        (Syntax.fakeNode
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (Syntax.fakeNode
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern "len"
                                            )
                                        , Syntax.fakeNode
                                            Elm.Syntax.Pattern.AllPattern
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tree"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode "array")
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "=="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "from")
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "array")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.IfBlock
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                ">="
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "from"
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tailIndex"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "len"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.OperatorApplication
                                "<|"
                                Elm.Syntax.Infix.Left
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "Array_elm_builtin"
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
                                                                "len"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "from"
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "shiftStep"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "empty"
                                            )
                                        ]
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "slice"
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
                                                                "from"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "tailIndex"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "len"
                                                                    )
                                                                ]
                                                            )
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
                                                                [ "JsArray" ]
                                                                "length"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "tail"
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                Syntax.fakeNode
                                                    { name =
                                                        Syntax.fakeNode "helper"
                                                    , arguments =
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "node"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "acc"
                                                            )
                                                        ]
                                                    , expression =
                                                        Syntax.fakeNode
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "node"
                                                                        )
                                                                , cases =
                                                                    [ ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "SubTree"
                                                                                }
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "subTree"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "JsArray"
                                                                                        ]
                                                                                        "foldr"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "helper"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "acc"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "subTree"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( Syntax.fakeNode
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Leaf"
                                                                                }
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "leaf"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                "::"
                                                                                Elm.Syntax.Infix.Left
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "leaf"
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
                                                    { name =
                                                        Syntax.fakeNode
                                                            "leafNodes"
                                                    , arguments = []
                                                    , expression =
                                                        Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldr"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "helper"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ListExpr
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "tail"
                                                                            )
                                                                        ]
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "tree"
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
                                                            "skipNodes"
                                                    , arguments = []
                                                    , expression =
                                                        Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "//"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "from"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "branchFactor"
                                                                    )
                                                                )
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
                                                            "nodesToInsert"
                                                    , arguments = []
                                                    , expression =
                                                        Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "drop"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "skipNodes"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "leafNodes"
                                                                    )
                                                                ]
                                                            )
                                                    }
                                            }
                                        )
                                    ]
                                , expression =
                                    Syntax.fakeNode
                                        (Elm.Syntax.Expression.CaseExpression
                                            { expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "nodesToInsert"
                                                    )
                                            , cases =
                                                [ ( Syntax.fakeNode
                                                        (Elm.Syntax.Pattern.ListPattern
                                                            []
                                                        )
                                                  , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "empty"
                                                        )
                                                  )
                                                , ( Syntax.fakeNode
                                                        (Elm.Syntax.Pattern.UnConsPattern
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Pattern.VarPattern
                                                                    "head"
                                                                )
                                                            )
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Pattern.VarPattern
                                                                    "rest"
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
                                                                                        "firstSlice"
                                                                                , arguments =
                                                                                    []
                                                                                , expression =
                                                                                    Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                                            "-"
                                                                                            Elm.Syntax.Infix.Left
                                                                                            (Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    []
                                                                                                    "from"
                                                                                                )
                                                                                            )
                                                                                            (Syntax.fakeNode
                                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                    (Syntax.fakeNode
                                                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                                                            "*"
                                                                                                            Elm.Syntax.Infix.Left
                                                                                                            (Syntax.fakeNode
                                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                    []
                                                                                                                    "skipNodes"
                                                                                                                )
                                                                                                            )
                                                                                                            (Syntax.fakeNode
                                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                    []
                                                                                                                    "branchFactor"
                                                                                                                )
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                }
                                                                        }
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.LetFunction
                                                                        { documentation =
                                                                            Nothing
                                                                        , signature =
                                                                            Nothing
                                                                        , declaration =
                                                                            Syntax.fakeNode
                                                                                { name =
                                                                                    Syntax.fakeNode
                                                                                        "initialBuilder"
                                                                                , arguments =
                                                                                    []
                                                                                , expression =
                                                                                    Syntax.fakeNode
                                                                                        (Elm.Syntax.Expression.RecordExpr
                                                                                            [ Syntax.fakeNode
                                                                                                ( Syntax.fakeNode
                                                                                                    "tail"
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                        [ Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                [ "JsArray"
                                                                                                                ]
                                                                                                                "slice"
                                                                                                            )
                                                                                                        , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "firstSlice"
                                                                                                            )
                                                                                                        , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                (Syntax.fakeNode
                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                        [ Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                [ "JsArray"
                                                                                                                                ]
                                                                                                                                "length"
                                                                                                                            )
                                                                                                                        , Syntax.fakeNode
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                []
                                                                                                                                "head"
                                                                                                                            )
                                                                                                                        ]
                                                                                                                    )
                                                                                                                )
                                                                                                            )
                                                                                                        , Syntax.fakeNode
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                []
                                                                                                                "head"
                                                                                                            )
                                                                                                        ]
                                                                                                    )
                                                                                                )
                                                                                            , Syntax.fakeNode
                                                                                                ( Syntax.fakeNode
                                                                                                    "nodeList"
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.ListExpr
                                                                                                        []
                                                                                                    )
                                                                                                )
                                                                                            , Syntax.fakeNode
                                                                                                ( Syntax.fakeNode
                                                                                                    "nodeListSize"
                                                                                                , Syntax.fakeNode
                                                                                                    (Elm.Syntax.Expression.Integer
                                                                                                        0
                                                                                                    )
                                                                                                )
                                                                                            ]
                                                                                        )
                                                                                }
                                                                        }
                                                                    )
                                                                ]
                                                            , expression =
                                                                Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "|>"
                                                                        Elm.Syntax.Infix.Left
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "List"
                                                                                        ]
                                                                                        "foldl"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "appendHelpBuilder"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "initialBuilder"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "rest"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "builderToArray"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "True"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                            }
                                                        )
                                                  )
                                                ]
                                            }
                                        )
                                }
                            )
                        )
                    )
                )
            )
    }


emptyBuilder : Elm.Syntax.Expression.FunctionImplementation
emptyBuilder =
    { name = Syntax.fakeNode "Array.emptyBuilder"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.RecordExpr
                [ Syntax.fakeNode
                    ( Syntax.fakeNode "tail"
                    , Syntax.fakeNode
                        (Elm.Syntax.Expression.FunctionOrValue
                            [ "JsArray" ]
                            "empty"
                        )
                    )
                , Syntax.fakeNode
                    ( Syntax.fakeNode "nodeList"
                    , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                    )
                , Syntax.fakeNode
                    ( Syntax.fakeNode "nodeListSize"
                    , Syntax.fakeNode (Elm.Syntax.Expression.Integer 0)
                    )
                ]
            )
    }


builderFromArray : Elm.Syntax.Expression.FunctionImplementation
builderFromArray =
    { name = Syntax.fakeNode "Array.builderFromArray"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "len")
                        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tree")
                        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "tail")
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
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "helper"
                                    , arguments =
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Pattern.VarPattern
                                                "node"
                                            )
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
                                                            "node"
                                                        )
                                                , cases =
                                                    [ ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldl"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "helper"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "acc"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( Syntax.fakeNode
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Leaf"
                                                                }
                                                                [ Syntax.fakeNode
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
                                                            )
                                                      , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "node"
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
                                                    ]
                                                }
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.RecordExpr
                            [ Syntax.fakeNode
                                ( Syntax.fakeNode "tail"
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "tail"
                                    )
                                )
                            , Syntax.fakeNode
                                ( Syntax.fakeNode "nodeList"
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "foldl"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "helper"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.ListExpr [])
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "tree"
                                            )
                                        ]
                                    )
                                )
                            , Syntax.fakeNode
                                ( Syntax.fakeNode "nodeListSize"
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "//"
                                        Elm.Syntax.Infix.Left
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "len"
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "branchFactor"
                                            )
                                        )
                                    )
                                )
                            ]
                        )
                }
            )
    }


builderToArray : Elm.Syntax.Expression.FunctionImplementation
builderToArray =
    { name = Syntax.fakeNode "Array.builderToArray"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "reverseNodeList")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "builder")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "=="
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.RecordAccess
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "builder"
                                    )
                                )
                                (Syntax.fakeNode "nodeListSize")
                            )
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                []
                                "Array_elm_builtin"
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "length"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.RecordAccess
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "builder"
                                                    )
                                                )
                                                (Syntax.fakeNode "tail")
                                            )
                                        ]
                                    )
                                )
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                []
                                "shiftStep"
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue
                                [ "JsArray" ]
                                "empty"
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.RecordAccess
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "builder"
                                    )
                                )
                                (Syntax.fakeNode "tail")
                            )
                        ]
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ Syntax.fakeNode
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        Syntax.fakeNode
                                            { name = Syntax.fakeNode "treeLen"
                                            , arguments = []
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "*"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.RecordAccess
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "builder"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    "nodeListSize"
                                                                )
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "branchFactor"
                                                            )
                                                        )
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
                                            { name = Syntax.fakeNode "depth"
                                            , arguments = []
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "|>"
                                                        Elm.Syntax.Infix.Left
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "|>"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "|>"
                                                                        Elm.Syntax.Infix.Left
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "-"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "treeLen"
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
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "toFloat"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "logBase"
                                                                            )
                                                                        , Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                (Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "toFloat"
                                                                                            )
                                                                                        , Syntax.fakeNode
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                []
                                                                                                "branchFactor"
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
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "floor"
                                                            )
                                                        )
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
                                                    "correctNodeList"
                                            , arguments = []
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.IfBlock
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "reverseNodeList"
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.RecordAccess
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                []
                                                                                "builder"
                                                                            )
                                                                        )
                                                                        (Syntax.fakeNode
                                                                            "nodeList"
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.RecordAccess
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "builder"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    "nodeList"
                                                                )
                                                            )
                                                        )
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
                                            { name = Syntax.fakeNode "tree"
                                            , arguments = []
                                            , expression =
                                                Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "treeFromBuilder"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "correctNodeList"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.RecordAccess
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "builder"
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    "nodeListSize"
                                                                )
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
                                            "Array_elm_builtin"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "+"
                                                    Elm.Syntax.Infix.Left
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.Application
                                                            [ Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    [ "JsArray"
                                                                    ]
                                                                    "length"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.RecordAccess
                                                                    (Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "builder"
                                                                        )
                                                                    )
                                                                    (Syntax.fakeNode
                                                                        "tail"
                                                                    )
                                                                )
                                                            ]
                                                        )
                                                    )
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "treeLen"
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "*"
                                                    Elm.Syntax.Infix.Left
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "<|"
                                                            Elm.Syntax.Infix.Left
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.Application
                                                                    [ Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "max"
                                                                        )
                                                                    , Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.Integer
                                                                            5
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "depth"
                                                                )
                                                            )
                                                        )
                                                    )
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "shiftStep"
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "tree"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.RecordAccess
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "builder"
                                                )
                                            )
                                            (Syntax.fakeNode "tail")
                                        )
                                    ]
                                )
                        }
                    )
                )
            )
    }


treeFromBuilder : Elm.Syntax.Expression.FunctionImplementation
treeFromBuilder =
    { name = Syntax.fakeNode "Array.treeFromBuilder"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "nodeList")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "nodeListSize")
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
                                    { name = Syntax.fakeNode "newNodeSize"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "|>"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "/"
                                                                Elm.Syntax.Infix.Left
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "toFloat"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "nodeListSize"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (Syntax.fakeNode
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "toFloat"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "branchFactor"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "ceiling"
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.IfBlock
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "=="
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "newNodeSize"
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Integer 1)
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "|>"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "initializeFromList"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "branchFactor"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "nodeList"
                                                )
                                            ]
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "Tuple" ]
                                            "first"
                                        )
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.Application
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "treeFromBuilder"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Application
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "compressNodes"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "nodeList"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.ListExpr
                                                            []
                                                        )
                                                    ]
                                                )
                                            )
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "newNodeSize"
                                        )
                                    ]
                                )
                            )
                        )
                }
            )
    }


compressNodes : Elm.Syntax.Expression.FunctionImplementation
compressNodes =
    { name = Syntax.fakeNode "Array.compressNodes"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "nodes")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "acc")
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
                                        (Elm.Syntax.Pattern.VarPattern "node")
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Pattern.VarPattern
                                            "remainingNodes"
                                        )
                                    ]
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.Application
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "JsArray" ]
                                            "initializeFromList"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "branchFactor"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "nodes"
                                        )
                                    ]
                                )
                            )
                        )
                    , Syntax.fakeNode
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                Syntax.fakeNode
                                    { name = Syntax.fakeNode "newAcc"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "::"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (Syntax.fakeNode
                                                            (Elm.Syntax.Expression.Application
                                                                [ Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "SubTree"
                                                                    )
                                                                , Syntax.fakeNode
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        []
                                                                        "node"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "acc"
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.CaseExpression
                            { expression =
                                Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "remainingNodes"
                                    )
                            , cases =
                                [ ( Syntax.fakeNode
                                        (Elm.Syntax.Pattern.ListPattern [])
                                  , Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "List" ]
                                                    "reverse"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "newAcc"
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
                                                    "compressNodes"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "remainingNodes"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "newAcc"
                                                )
                                            ]
                                        )
                                  )
                                ]
                            }
                        )
                }
            )
    }