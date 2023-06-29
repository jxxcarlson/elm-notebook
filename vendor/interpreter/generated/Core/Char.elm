module Core.Char exposing (fromCode, functions, isAlpha, isAlphaNum, isDigit, isHexDigit, isLower, isOctDigit, isUpper, toCode, toLocaleLower, toLocaleUpper, toLower, toUpper)

{-| 
@docs functions, isUpper, isLower, isAlpha, isAlphaNum, isDigit, isOctDigit, isHexDigit, toUpper, toLower, toLocaleUpper, toLocaleLower, toCode, fromCode
-}


import Elm.Syntax.Expression
import Elm.Syntax.Infix
import Elm.Syntax.Pattern
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "isUpper", isUpper )
        , ( "isLower", isLower )
        , ( "isAlpha", isAlpha )
        , ( "isAlphaNum", isAlphaNum )
        , ( "isDigit", isDigit )
        , ( "isOctDigit", isOctDigit )
        , ( "isHexDigit", isHexDigit )
        , ( "toUpper", toUpper )
        , ( "toLower", toLower )
        , ( "toLocaleUpper", toLocaleUpper )
        , ( "toLocaleLower", toLocaleLower )
        , ( "toCode", toCode )
        , ( "fromCode", fromCode )
        ]


isUpper : Elm.Syntax.Expression.FunctionImplementation
isUpper =
    { name = Syntax.fakeNode "Char.isUpper"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "char") ]
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
                                    { name = Syntax.fakeNode "code"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "toCode"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "char"
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
                            "<="
                            Elm.Syntax.Infix.Left
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "&&"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "<="
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "code"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Hex 0x5A)
                                            )
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Hex 0x41)
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "code"
                                )
                            )
                        )
                }
            )
    }


isLower : Elm.Syntax.Expression.FunctionImplementation
isLower =
    { name = Syntax.fakeNode "Char.isLower"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "char") ]
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
                                    { name = Syntax.fakeNode "code"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "toCode"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "char"
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
                            "<="
                            Elm.Syntax.Infix.Left
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "&&"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "<="
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Hex 0x61)
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "code"
                                                )
                                            )
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            []
                                            "code"
                                        )
                                    )
                                )
                            )
                            (Syntax.fakeNode (Elm.Syntax.Expression.Hex 0x7A))
                        )
                }
            )
    }


isAlpha : Elm.Syntax.Expression.FunctionImplementation
isAlpha =
    { name = Syntax.fakeNode "Char.isAlpha"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "char") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.OperatorApplication
                "||"
                Elm.Syntax.Infix.Left
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "isLower")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "char")
                        ]
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "isUpper")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "char")
                        ]
                    )
                )
            )
    }


isAlphaNum : Elm.Syntax.Expression.FunctionImplementation
isAlphaNum =
    { name = Syntax.fakeNode "Char.isAlphaNum"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "char") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.OperatorApplication
                "||"
                Elm.Syntax.Infix.Left
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.OperatorApplication
                        "||"
                        Elm.Syntax.Infix.Left
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "isLower"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "char"
                                    )
                                ]
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "isUpper"
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
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "isDigit")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "char")
                        ]
                    )
                )
            )
    }


isDigit : Elm.Syntax.Expression.FunctionImplementation
isDigit =
    { name = Syntax.fakeNode "Char.isDigit"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "char") ]
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
                                    { name = Syntax.fakeNode "code"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "toCode"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "char"
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
                            "<="
                            Elm.Syntax.Infix.Left
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "&&"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "<="
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "code"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Hex 0x39)
                                            )
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Hex 0x30)
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "code"
                                )
                            )
                        )
                }
            )
    }


isOctDigit : Elm.Syntax.Expression.FunctionImplementation
isOctDigit =
    { name = Syntax.fakeNode "Char.isOctDigit"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "char") ]
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
                                    { name = Syntax.fakeNode "code"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "toCode"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "char"
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
                            "<="
                            Elm.Syntax.Infix.Left
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "&&"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "<="
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    []
                                                    "code"
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Hex 0x37)
                                            )
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.Hex 0x30)
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.FunctionOrValue [] "code"
                                )
                            )
                        )
                }
            )
    }


isHexDigit : Elm.Syntax.Expression.FunctionImplementation
isHexDigit =
    { name = Syntax.fakeNode "Char.isHexDigit"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "char") ]
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
                                    { name = Syntax.fakeNode "code"
                                    , arguments = []
                                    , expression =
                                        Syntax.fakeNode
                                            (Elm.Syntax.Expression.Application
                                                [ Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "toCode"
                                                    )
                                                , Syntax.fakeNode
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        []
                                                        "char"
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
                            "||"
                            Elm.Syntax.Infix.Left
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.OperatorApplication
                                    "||"
                                    Elm.Syntax.Infix.Left
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "<="
                                                    Elm.Syntax.Infix.Left
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "&&"
                                                            Elm.Syntax.Infix.Left
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "<="
                                                                    Elm.Syntax.Infix.Left
                                                                    (Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.Hex
                                                                            0x30
                                                                        )
                                                                    )
                                                                    (Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "code"
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "code"
                                                                )
                                                            )
                                                        )
                                                    )
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.Hex
                                                            0x39
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "<="
                                                    Elm.Syntax.Infix.Left
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "&&"
                                                            Elm.Syntax.Infix.Left
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "<="
                                                                    Elm.Syntax.Infix.Left
                                                                    (Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.Hex
                                                                            0x41
                                                                        )
                                                                    )
                                                                    (Syntax.fakeNode
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            []
                                                                            "code"
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "code"
                                                                )
                                                            )
                                                        )
                                                    )
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.Hex
                                                            0x46
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                            (Syntax.fakeNode
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (Syntax.fakeNode
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "<="
                                            Elm.Syntax.Infix.Left
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "&&"
                                                    Elm.Syntax.Infix.Left
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "<="
                                                            Elm.Syntax.Infix.Left
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.Hex
                                                                    0x61
                                                                )
                                                            )
                                                            (Syntax.fakeNode
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    []
                                                                    "code"
                                                                )
                                                            )
                                                        )
                                                    )
                                                    (Syntax.fakeNode
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            []
                                                            "code"
                                                        )
                                                    )
                                                )
                                            )
                                            (Syntax.fakeNode
                                                (Elm.Syntax.Expression.Hex 0x66)
                                            )
                                        )
                                    )
                                )
                            )
                        )
                }
            )
    }


toUpper : Elm.Syntax.Expression.FunctionImplementation
toUpper =
    { name = Syntax.fakeNode "Char.toUpper"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "toUpper"
            )
    }


toLower : Elm.Syntax.Expression.FunctionImplementation
toLower =
    { name = Syntax.fakeNode "Char.toLower"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "toLower"
            )
    }


toLocaleUpper : Elm.Syntax.Expression.FunctionImplementation
toLocaleUpper =
    { name = Syntax.fakeNode "Char.toLocaleUpper"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "toLocaleUpper"
            )
    }


toLocaleLower : Elm.Syntax.Expression.FunctionImplementation
toLocaleLower =
    { name = Syntax.fakeNode "Char.toLocaleLower"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "toLocaleLower"
            )
    }


toCode : Elm.Syntax.Expression.FunctionImplementation
toCode =
    { name = Syntax.fakeNode "Char.toCode"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "toCode"
            )
    }


fromCode : Elm.Syntax.Expression.FunctionImplementation
fromCode =
    { name = Syntax.fakeNode "Char.fromCode"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "fromCode"
            )
    }