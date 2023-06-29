module Core.String exposing (all, any, append, concat, cons, contains, dropLeft, dropRight, endsWith, filter, foldl, foldr, fromChar, fromFloat, fromInt, fromList, functions, indexes, indices, isEmpty, join, left, length, lines, map, pad, padLeft, padRight, repeat, repeatHelp, replace, reverse, right, slice, split, startsWith, toFloat, toInt, toList, toLower, toUpper, trim, trimLeft, trimRight, uncons, words)

{-| 
@docs functions, isEmpty, length, reverse, repeat, repeatHelp, replace, append, concat, split, join, words, lines, slice, left, right, dropLeft, dropRight, contains, startsWith, endsWith, indexes, indices, toUpper, toLower, pad, padLeft, padRight, trim, trimLeft, trimRight, toInt, fromInt, toFloat, fromFloat, toList, fromList, fromChar, cons, uncons, map, filter, foldl, foldr, any, all
-}


import Elm.Syntax.Expression
import Elm.Syntax.Infix
import Elm.Syntax.Pattern
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "isEmpty", isEmpty )
        , ( "length", length )
        , ( "reverse", reverse )
        , ( "repeat", repeat )
        , ( "repeatHelp", repeatHelp )
        , ( "replace", replace )
        , ( "append", append )
        , ( "concat", concat )
        , ( "split", split )
        , ( "join", join )
        , ( "words", words )
        , ( "lines", lines )
        , ( "slice", slice )
        , ( "left", left )
        , ( "right", right )
        , ( "dropLeft", dropLeft )
        , ( "dropRight", dropRight )
        , ( "contains", contains )
        , ( "startsWith", startsWith )
        , ( "endsWith", endsWith )
        , ( "indexes", indexes )
        , ( "indices", indices )
        , ( "toUpper", toUpper )
        , ( "toLower", toLower )
        , ( "pad", pad )
        , ( "padLeft", padLeft )
        , ( "padRight", padRight )
        , ( "trim", trim )
        , ( "trimLeft", trimLeft )
        , ( "trimRight", trimRight )
        , ( "toInt", toInt )
        , ( "fromInt", fromInt )
        , ( "toFloat", toFloat )
        , ( "fromFloat", fromFloat )
        , ( "toList", toList )
        , ( "fromList", fromList )
        , ( "fromChar", fromChar )
        , ( "cons", cons )
        , ( "uncons", uncons )
        , ( "map", map )
        , ( "filter", filter )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        , ( "any", any )
        , ( "all", all )
        ]


isEmpty : Elm.Syntax.Expression.FunctionImplementation
isEmpty =
    { name = Syntax.fakeNode "String.isEmpty"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "string") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.OperatorApplication
                "=="
                Elm.Syntax.Infix.Left
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "string")
                )
                (Syntax.fakeNode (Elm.Syntax.Expression.Literal ""))
            )
    }


length : Elm.Syntax.Expression.FunctionImplementation
length =
    { name = Syntax.fakeNode "String.length"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "length"
            )
    }


reverse : Elm.Syntax.Expression.FunctionImplementation
reverse =
    { name = Syntax.fakeNode "String.reverse"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "reverse"
            )
    }


repeat : Elm.Syntax.Expression.FunctionImplementation
repeat =
    { name = Syntax.fakeNode "String.repeat"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "chunk")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "repeatHelp")
                , Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "n")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "chunk")
                , Syntax.fakeNode (Elm.Syntax.Expression.Literal "")
                ]
            )
    }


repeatHelp : Elm.Syntax.Expression.FunctionImplementation
repeatHelp =
    { name = Syntax.fakeNode "String.repeatHelp"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "chunk")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "result")
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
                    (Elm.Syntax.Expression.OperatorApplication
                        "<|"
                        Elm.Syntax.Infix.Left
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
                                                        [ "Bitwise" ]
                                                        "shiftRightBy"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Integer
                                                        1
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "n"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "++"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "chunk"
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "chunk"
                                                    )
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
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "Bitwise" ]
                                                        "and"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "n"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Integer
                                                        1
                                                    )
                                                ]
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
                                        "result"
                                    )
                                )
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "++"
                                        Elm.Syntax.Infix.Left
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "result"
                                            )
                                        )
                                        (Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "chunk"
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
    }


replace : Elm.Syntax.Expression.FunctionImplementation
replace =
    { name = Syntax.fakeNode "String.replace"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "before")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "after")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "join")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "after")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
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
                                        "before"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "string"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


append : Elm.Syntax.Expression.FunctionImplementation
append =
    { name = Syntax.fakeNode "String.append"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "append"
            )
    }


concat : Elm.Syntax.Expression.FunctionImplementation
concat =
    { name = Syntax.fakeNode "String.concat"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "strings") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "join")
                , Syntax.fakeNode (Elm.Syntax.Expression.Literal "")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "strings")
                ]
            )
    }


split : Elm.Syntax.Expression.FunctionImplementation
split =
    { name = Syntax.fakeNode "String.split"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "sep")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue
                        [ "Elm", "Kernel", "List" ]
                        "fromArray"
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Elm", "Kernel", "String" ]
                                        "split"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "sep"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "string"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


join : Elm.Syntax.Expression.FunctionImplementation
join =
    { name = Syntax.fakeNode "String.join"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "sep")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "chunks")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue
                        [ "Elm", "Kernel", "String" ]
                        "join"
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "sep")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Elm", "Kernel", "List" ]
                                        "toArray"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "chunks"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


words : Elm.Syntax.Expression.FunctionImplementation
words =
    { name = Syntax.fakeNode "String.words"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "words"
            )
    }


lines : Elm.Syntax.Expression.FunctionImplementation
lines =
    { name = Syntax.fakeNode "String.lines"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "lines"
            )
    }


slice : Elm.Syntax.Expression.FunctionImplementation
slice =
    { name = Syntax.fakeNode "String.slice"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "slice"
            )
    }


left : Elm.Syntax.Expression.FunctionImplementation
left =
    { name = Syntax.fakeNode "String.left"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 1))
                    )
                )
                (Syntax.fakeNode (Elm.Syntax.Expression.Literal ""))
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "slice")
                        , Syntax.fakeNode (Elm.Syntax.Expression.Integer 0)
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "string")
                        ]
                    )
                )
            )
    }


right : Elm.Syntax.Expression.FunctionImplementation
right =
    { name = Syntax.fakeNode "String.right"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 1))
                    )
                )
                (Syntax.fakeNode (Elm.Syntax.Expression.Literal ""))
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "slice")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.Negation
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "n"
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
                                                "length"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "string"
                                            )
                                        ]
                                    )
                                )
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "string")
                        ]
                    )
                )
            )
    }


dropLeft : Elm.Syntax.Expression.FunctionImplementation
dropLeft =
    { name = Syntax.fakeNode "String.dropLeft"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 1))
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "string")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "slice")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.ParenthesizedExpression
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
                                                "string"
                                            )
                                        ]
                                    )
                                )
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "string")
                        ]
                    )
                )
            )
    }


dropRight : Elm.Syntax.Expression.FunctionImplementation
dropRight =
    { name = Syntax.fakeNode "String.dropRight"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        )
                        (Syntax.fakeNode (Elm.Syntax.Expression.Integer 1))
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "string")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "slice")
                        , Syntax.fakeNode (Elm.Syntax.Expression.Integer 0)
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.Negation
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "n"
                                    )
                                )
                            )
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "string")
                        ]
                    )
                )
            )
    }


contains : Elm.Syntax.Expression.FunctionImplementation
contains =
    { name = Syntax.fakeNode "String.contains"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "contains"
            )
    }


startsWith : Elm.Syntax.Expression.FunctionImplementation
startsWith =
    { name = Syntax.fakeNode "String.startsWith"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "startsWith"
            )
    }


endsWith : Elm.Syntax.Expression.FunctionImplementation
endsWith =
    { name = Syntax.fakeNode "String.endsWith"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "endsWith"
            )
    }


indexes : Elm.Syntax.Expression.FunctionImplementation
indexes =
    { name = Syntax.fakeNode "String.indexes"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "indexes"
            )
    }


indices : Elm.Syntax.Expression.FunctionImplementation
indices =
    { name = Syntax.fakeNode "String.indices"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "indexes"
            )
    }


toUpper : Elm.Syntax.Expression.FunctionImplementation
toUpper =
    { name = Syntax.fakeNode "String.toUpper"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "toUpper"
            )
    }


toLower : Elm.Syntax.Expression.FunctionImplementation
toLower =
    { name = Syntax.fakeNode "String.toLower"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "toLower"
            )
    }


pad : Elm.Syntax.Expression.FunctionImplementation
pad =
    { name = Syntax.fakeNode "String.pad"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "char")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "string")
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
                                    { name = Syntax.fakeNode "half"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "/"
                                                Elm.Syntax.Infix.Left
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Basics" ]
                                                                "toFloat"
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
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "length"
                                                                                    )
                                                                                , Syntax.fakeNode
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        []
                                                                                        "string"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        ]
                                                    )
                                                )
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Integer
                                                        2
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    Syntax.fakeNode
                        (Elm.Syntax.Expression.OperatorApplication
                            "++"
                            Elm.Syntax.Infix.Left
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "++"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Application
                                            [ Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "repeat"
                                                )
                                            , Syntax.fakeNode
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.Application
                                                            [ Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "ceiling"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "half"
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
                                                                    "fromChar"
                                                                )
                                                            , Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "char"
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "string"
                                        )
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.Application
                                    [ Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "repeat"
                                        )
                                    , Syntax.fakeNode
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Application
                                                    [ Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "floor"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "half"
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
                                                            "fromChar"
                                                        )
                                                    , Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "char"
                                                        )
                                                    ]
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


padLeft : Elm.Syntax.Expression.FunctionImplementation
padLeft =
    { name = Syntax.fakeNode "String.padLeft"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "char")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.OperatorApplication
                "++"
                Elm.Syntax.Infix.Left
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "repeat")
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
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "length"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "string"
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
                                                "fromChar"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "char"
                                            )
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "string")
                )
            )
    }


padRight : Elm.Syntax.Expression.FunctionImplementation
padRight =
    { name = Syntax.fakeNode "String.padRight"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "char")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.OperatorApplication
                "++"
                Elm.Syntax.Infix.Left
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "string")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "repeat")
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
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "length"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "string"
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
                                                "fromChar"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "char"
                                            )
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                )
            )
    }


trim : Elm.Syntax.Expression.FunctionImplementation
trim =
    { name = Syntax.fakeNode "String.trim"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "trim"
            )
    }


trimLeft : Elm.Syntax.Expression.FunctionImplementation
trimLeft =
    { name = Syntax.fakeNode "String.trimLeft"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "trimLeft"
            )
    }


trimRight : Elm.Syntax.Expression.FunctionImplementation
trimRight =
    { name = Syntax.fakeNode "String.trimRight"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "trimRight"
            )
    }


toInt : Elm.Syntax.Expression.FunctionImplementation
toInt =
    { name = Syntax.fakeNode "String.toInt"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "toInt"
            )
    }


fromInt : Elm.Syntax.Expression.FunctionImplementation
fromInt =
    { name = Syntax.fakeNode "String.fromInt"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "fromNumber"
            )
    }


toFloat : Elm.Syntax.Expression.FunctionImplementation
toFloat =
    { name = Syntax.fakeNode "String.toFloat"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "toFloat"
            )
    }


fromFloat : Elm.Syntax.Expression.FunctionImplementation
fromFloat =
    { name = Syntax.fakeNode "String.fromFloat"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "fromNumber"
            )
    }


toList : Elm.Syntax.Expression.FunctionImplementation
toList =
    { name = Syntax.fakeNode "String.toList"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "string") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "foldr")
                , Syntax.fakeNode (Elm.Syntax.Expression.PrefixOperator "::")
                , Syntax.fakeNode (Elm.Syntax.Expression.ListExpr [])
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "string")
                ]
            )
    }


fromList : Elm.Syntax.Expression.FunctionImplementation
fromList =
    { name = Syntax.fakeNode "String.fromList"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "fromList"
            )
    }


fromChar : Elm.Syntax.Expression.FunctionImplementation
fromChar =
    { name = Syntax.fakeNode "String.fromChar"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "char") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "cons")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "char")
                , Syntax.fakeNode (Elm.Syntax.Expression.Literal "")
                ]
            )
    }


cons : Elm.Syntax.Expression.FunctionImplementation
cons =
    { name = Syntax.fakeNode "String.cons"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "cons"
            )
    }


uncons : Elm.Syntax.Expression.FunctionImplementation
uncons =
    { name = Syntax.fakeNode "String.uncons"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "uncons"
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = Syntax.fakeNode "String.map"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "map"
            )
    }


filter : Elm.Syntax.Expression.FunctionImplementation
filter =
    { name = Syntax.fakeNode "String.filter"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "filter"
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = Syntax.fakeNode "String.foldl"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "foldl"
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = Syntax.fakeNode "String.foldr"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "foldr"
            )
    }


any : Elm.Syntax.Expression.FunctionImplementation
any =
    { name = Syntax.fakeNode "String.any"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "any"
            )
    }


all : Elm.Syntax.Expression.FunctionImplementation
all =
    { name = Syntax.fakeNode "String.all"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "all"
            )
    }