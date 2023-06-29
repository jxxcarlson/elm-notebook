module Core.Basics exposing (abs, acos, add, always, and, apL, apR, append, asin, atan, atan2, ceiling, clamp, compare, composeL, composeR, cos, degrees, e, eq, fdiv, floor, fromPolar, functions, ge, gt, identity, idiv, isInfinite, isNaN, le, logBase, lt, max, min, modBy, mul, negate, neq, never, not, operators, or, pi, pow, radians, remainderBy, round, sin, sqrt, sub, tan, toFloat, toPolar, truncate, turns, xor)

{-| 
@docs functions, operators, add, sub, mul, fdiv, idiv, pow, toFloat, round, floor, ceiling, truncate, eq, neq, lt, gt, le, ge, min, max, compare, not, and, or, xor, append, modBy, remainderBy, negate, abs, clamp, sqrt, logBase, e, radians, degrees, turns, pi, cos, sin, tan, acos, asin, atan, atan2, fromPolar, toPolar, isNaN, isInfinite, composeL, composeR, apR, apL, identity, always, never
-}


import Elm.Syntax.Expression
import Elm.Syntax.Pattern
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "add", add )
        , ( "sub", sub )
        , ( "mul", mul )
        , ( "fdiv", fdiv )
        , ( "idiv", idiv )
        , ( "pow", pow )
        , ( "toFloat", toFloat )
        , ( "round", round )
        , ( "floor", floor )
        , ( "ceiling", ceiling )
        , ( "truncate", truncate )
        , ( "eq", eq )
        , ( "neq", neq )
        , ( "lt", lt )
        , ( "gt", gt )
        , ( "le", le )
        , ( "ge", ge )
        , ( "min", min )
        , ( "max", max )
        , ( "compare", compare )
        , ( "not", not )
        , ( "and", and )
        , ( "or", or )
        , ( "xor", xor )
        , ( "append", append )
        , ( "modBy", modBy )
        , ( "remainderBy", remainderBy )
        , ( "negate", negate )
        , ( "abs", abs )
        , ( "clamp", clamp )
        , ( "sqrt", sqrt )
        , ( "logBase", logBase )
        , ( "e", e )
        , ( "radians", radians )
        , ( "degrees", degrees )
        , ( "turns", turns )
        , ( "pi", pi )
        , ( "cos", cos )
        , ( "sin", sin )
        , ( "tan", tan )
        , ( "acos", acos )
        , ( "asin", asin )
        , ( "atan", atan )
        , ( "atan2", atan2 )
        , ( "fromPolar", fromPolar )
        , ( "toPolar", toPolar )
        , ( "isNaN", isNaN )
        , ( "isInfinite", isInfinite )
        , ( "composeL", composeL )
        , ( "composeR", composeR )
        , ( "apR", apR )
        , ( "apL", apL )
        , ( "identity", identity )
        , ( "always", always )
        , ( "never", never )
        ]


operators : List ( String, Elm.Syntax.Pattern.QualifiedNameRef )
operators =
    [ ( "<|", { moduleName = [ "Basics" ], name = "apL" } )
    , ( "|>", { moduleName = [ "Basics" ], name = "apR" } )
    , ( "||", { moduleName = [ "Basics" ], name = "or" } )
    , ( "&&", { moduleName = [ "Basics" ], name = "and" } )
    , ( "==", { moduleName = [ "Basics" ], name = "eq" } )
    , ( "/=", { moduleName = [ "Basics" ], name = "neq" } )
    , ( "<", { moduleName = [ "Basics" ], name = "lt" } )
    , ( ">", { moduleName = [ "Basics" ], name = "gt" } )
    , ( "<=", { moduleName = [ "Basics" ], name = "le" } )
    , ( ">=", { moduleName = [ "Basics" ], name = "ge" } )
    , ( "++", { moduleName = [ "Basics" ], name = "append" } )
    , ( "+", { moduleName = [ "Basics" ], name = "add" } )
    , ( "-", { moduleName = [ "Basics" ], name = "sub" } )
    , ( "*", { moduleName = [ "Basics" ], name = "mul" } )
    , ( "/", { moduleName = [ "Basics" ], name = "fdiv" } )
    , ( "//", { moduleName = [ "Basics" ], name = "idiv" } )
    , ( "^", { moduleName = [ "Basics" ], name = "pow" } )
    , ( "<<", { moduleName = [ "Basics" ], name = "composeL" } )
    , ( ">>", { moduleName = [ "Basics" ], name = "composeR" } )
    ]


add : Elm.Syntax.Expression.FunctionImplementation
add =
    { name = Syntax.fakeNode "Basics.add"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "add"
            )
    }


sub : Elm.Syntax.Expression.FunctionImplementation
sub =
    { name = Syntax.fakeNode "Basics.sub"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "sub"
            )
    }


mul : Elm.Syntax.Expression.FunctionImplementation
mul =
    { name = Syntax.fakeNode "Basics.mul"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "mul"
            )
    }


fdiv : Elm.Syntax.Expression.FunctionImplementation
fdiv =
    { name = Syntax.fakeNode "Basics.fdiv"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "fdiv"
            )
    }


idiv : Elm.Syntax.Expression.FunctionImplementation
idiv =
    { name = Syntax.fakeNode "Basics.idiv"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "idiv"
            )
    }


pow : Elm.Syntax.Expression.FunctionImplementation
pow =
    { name = Syntax.fakeNode "Basics.pow"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "pow"
            )
    }


toFloat : Elm.Syntax.Expression.FunctionImplementation
toFloat =
    { name = Syntax.fakeNode "Basics.toFloat"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "toFloat"
            )
    }


round : Elm.Syntax.Expression.FunctionImplementation
round =
    { name = Syntax.fakeNode "Basics.round"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "round"
            )
    }


floor : Elm.Syntax.Expression.FunctionImplementation
floor =
    { name = Syntax.fakeNode "Basics.floor"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "floor"
            )
    }


ceiling : Elm.Syntax.Expression.FunctionImplementation
ceiling =
    { name = Syntax.fakeNode "Basics.ceiling"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "ceiling"
            )
    }


truncate : Elm.Syntax.Expression.FunctionImplementation
truncate =
    { name = Syntax.fakeNode "Basics.truncate"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "truncate"
            )
    }


eq : Elm.Syntax.Expression.FunctionImplementation
eq =
    { name = Syntax.fakeNode "Basics.eq"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "equal"
            )
    }


neq : Elm.Syntax.Expression.FunctionImplementation
neq =
    { name = Syntax.fakeNode "Basics.neq"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "notEqual"
            )
    }


lt : Elm.Syntax.Expression.FunctionImplementation
lt =
    { name = Syntax.fakeNode "Basics.lt"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "lt"
            )
    }


gt : Elm.Syntax.Expression.FunctionImplementation
gt =
    { name = Syntax.fakeNode "Basics.gt"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "gt"
            )
    }


le : Elm.Syntax.Expression.FunctionImplementation
le =
    { name = Syntax.fakeNode "Basics.le"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "le"
            )
    }


ge : Elm.Syntax.Expression.FunctionImplementation
ge =
    { name = Syntax.fakeNode "Basics.ge"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "ge"
            )
    }


min : Elm.Syntax.Expression.FunctionImplementation
min =
    { name = Syntax.fakeNode "Basics.min"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "y")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "lt")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "x")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "y")
                        ]
                    )
                )
                (Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "x"))
                (Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "y"))
            )
    }


max : Elm.Syntax.Expression.FunctionImplementation
max =
    { name = Syntax.fakeNode "Basics.max"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "y")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "gt")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "x")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "y")
                        ]
                    )
                )
                (Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "x"))
                (Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "y"))
            )
    }


compare : Elm.Syntax.Expression.FunctionImplementation
compare =
    { name = Syntax.fakeNode "Basics.compare"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "compare"
            )
    }


not : Elm.Syntax.Expression.FunctionImplementation
not =
    { name = Syntax.fakeNode "Basics.not"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "not"
            )
    }


and : Elm.Syntax.Expression.FunctionImplementation
and =
    { name = Syntax.fakeNode "Basics.and"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "and"
            )
    }


or : Elm.Syntax.Expression.FunctionImplementation
or =
    { name = Syntax.fakeNode "Basics.or"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "or"
            )
    }


xor : Elm.Syntax.Expression.FunctionImplementation
xor =
    { name = Syntax.fakeNode "Basics.xor"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "xor"
            )
    }


append : Elm.Syntax.Expression.FunctionImplementation
append =
    { name = Syntax.fakeNode "Basics.append"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "append"
            )
    }


modBy : Elm.Syntax.Expression.FunctionImplementation
modBy =
    { name = Syntax.fakeNode "Basics.modBy"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "modBy"
            )
    }


remainderBy : Elm.Syntax.Expression.FunctionImplementation
remainderBy =
    { name = Syntax.fakeNode "Basics.remainderBy"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "remainderBy"
            )
    }


negate : Elm.Syntax.Expression.FunctionImplementation
negate =
    { name = Syntax.fakeNode "Basics.negate"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Negation
                (Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "n"))
            )
    }


abs : Elm.Syntax.Expression.FunctionImplementation
abs =
    { name = Syntax.fakeNode "Basics.abs"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "n") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "lt")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        , Syntax.fakeNode (Elm.Syntax.Expression.Integer 0)
                        ]
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Negation
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "n")
                        )
                    )
                )
                (Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "n"))
            )
    }


clamp : Elm.Syntax.Expression.FunctionImplementation
clamp =
    { name = Syntax.fakeNode "Basics.clamp"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "low")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "high")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "number")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.IfBlock
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "lt")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "number")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "low")
                        ]
                    )
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "low")
                )
                (Syntax.fakeNode
                    (Elm.Syntax.Expression.IfBlock
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "gt"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "number"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "high"
                                    )
                                ]
                            )
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "high")
                        )
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "number")
                        )
                    )
                )
            )
    }


sqrt : Elm.Syntax.Expression.FunctionImplementation
sqrt =
    { name = Syntax.fakeNode "Basics.sqrt"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "sqrt"
            )
    }


logBase : Elm.Syntax.Expression.FunctionImplementation
logBase =
    { name = Syntax.fakeNode "Basics.logBase"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "base")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "number")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "fdiv")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Elm", "Kernel", "Basics" ]
                                        "log"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "number"
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
                                        [ "Elm", "Kernel", "Basics" ]
                                        "log"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "base"
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
    }


e : Elm.Syntax.Expression.FunctionImplementation
e =
    { name = Syntax.fakeNode "Basics.e"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "e"
            )
    }


radians : Elm.Syntax.Expression.FunctionImplementation
radians =
    { name = Syntax.fakeNode "Basics.radians"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "angleInRadians") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue [] "angleInRadians")
    }


degrees : Elm.Syntax.Expression.FunctionImplementation
degrees =
    { name = Syntax.fakeNode "Basics.degrees"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "angleInDegrees") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "fdiv")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "mul"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "angleInDegrees"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "pi"
                                    )
                                ]
                            )
                        )
                    )
                , Syntax.fakeNode (Elm.Syntax.Expression.Integer 180)
                ]
            )
    }


turns : Elm.Syntax.Expression.FunctionImplementation
turns =
    { name = Syntax.fakeNode "Basics.turns"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "angleInTurns") ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "mul")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (Syntax.fakeNode
                            (Elm.Syntax.Expression.Application
                                [ Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "mul"
                                    )
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.Integer 2)
                                , Syntax.fakeNode
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        []
                                        "pi"
                                    )
                                ]
                            )
                        )
                    )
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "angleInTurns")
                ]
            )
    }


pi : Elm.Syntax.Expression.FunctionImplementation
pi =
    { name = Syntax.fakeNode "Basics.pi"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "pi"
            )
    }


cos : Elm.Syntax.Expression.FunctionImplementation
cos =
    { name = Syntax.fakeNode "Basics.cos"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "cos"
            )
    }


sin : Elm.Syntax.Expression.FunctionImplementation
sin =
    { name = Syntax.fakeNode "Basics.sin"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "sin"
            )
    }


tan : Elm.Syntax.Expression.FunctionImplementation
tan =
    { name = Syntax.fakeNode "Basics.tan"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "tan"
            )
    }


acos : Elm.Syntax.Expression.FunctionImplementation
acos =
    { name = Syntax.fakeNode "Basics.acos"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "acos"
            )
    }


asin : Elm.Syntax.Expression.FunctionImplementation
asin =
    { name = Syntax.fakeNode "Basics.asin"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "asin"
            )
    }


atan : Elm.Syntax.Expression.FunctionImplementation
atan =
    { name = Syntax.fakeNode "Basics.atan"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "atan"
            )
    }


atan2 : Elm.Syntax.Expression.FunctionImplementation
atan2 =
    { name = Syntax.fakeNode "Basics.atan2"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "atan2"
            )
    }


fromPolar : Elm.Syntax.Expression.FunctionImplementation
fromPolar =
    { name = Syntax.fakeNode "Basics.fromPolar"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.TuplePattern
                [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "radius")
                , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "theta")
                ]
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.TupledExpression
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "mul")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "radius")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "cos"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "theta"
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
                            (Elm.Syntax.Expression.FunctionOrValue [] "mul")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "radius")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "sin"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "theta"
                                            )
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                ]
            )
    }


toPolar : Elm.Syntax.Expression.FunctionImplementation
toPolar =
    { name = Syntax.fakeNode "Basics.toPolar"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.TuplePattern
                [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
                , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "y")
                ]
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.TupledExpression
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "sqrt")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (Syntax.fakeNode
                                    (Elm.Syntax.Expression.Application
                                        [ Syntax.fakeNode
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                []
                                                "add"
                                            )
                                        , Syntax.fakeNode
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "mul"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "x"
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
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (Syntax.fakeNode
                                                    (Elm.Syntax.Expression.Application
                                                        [ Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "mul"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "y"
                                                            )
                                                        , Syntax.fakeNode
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                []
                                                                "y"
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
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.Application
                        [ Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "atan2")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "y")
                        , Syntax.fakeNode
                            (Elm.Syntax.Expression.FunctionOrValue [] "x")
                        ]
                    )
                ]
            )
    }


isNaN : Elm.Syntax.Expression.FunctionImplementation
isNaN =
    { name = Syntax.fakeNode "Basics.isNaN"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "isNaN"
            )
    }


isInfinite : Elm.Syntax.Expression.FunctionImplementation
isInfinite =
    { name = Syntax.fakeNode "Basics.isInfinite"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "isInfinite"
            )
    }


composeL : Elm.Syntax.Expression.FunctionImplementation
composeL =
    { name = Syntax.fakeNode "Basics.composeL"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "g")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "g")
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
                ]
            )
    }


composeR : Elm.Syntax.Expression.FunctionImplementation
composeR =
    { name = Syntax.fakeNode "Basics.composeR"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "g")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "g")
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
                ]
            )
    }


apR : Elm.Syntax.Expression.FunctionImplementation
apR =
    { name = Syntax.fakeNode "Basics.apR"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "f")
                , Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "x")
                ]
            )
    }


apL : Elm.Syntax.Expression.FunctionImplementation
apL =
    { name = Syntax.fakeNode "Basics.apL"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "f")
        , Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x")
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "f")
                , Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "x")
                ]
            )
    }


identity : Elm.Syntax.Expression.FunctionImplementation
identity =
    { name = Syntax.fakeNode "Basics.identity"
    , arguments = [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "x") ]
    , expression =
        Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "x")
    }


always : Elm.Syntax.Expression.FunctionImplementation
always =
    { name = Syntax.fakeNode "Basics.always"
    , arguments =
        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "a")
        , Syntax.fakeNode Elm.Syntax.Pattern.AllPattern
        ]
    , expression =
        Syntax.fakeNode (Elm.Syntax.Expression.FunctionOrValue [] "a")
    }


never : Elm.Syntax.Expression.FunctionImplementation
never =
    { name = Syntax.fakeNode "Basics.never"
    , arguments =
        [ Syntax.fakeNode
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (Syntax.fakeNode
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "JustOneMore" }
                        [ Syntax.fakeNode (Elm.Syntax.Pattern.VarPattern "nvr")
                        ]
                    )
                )
            )
        ]
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.Application
                [ Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "never")
                , Syntax.fakeNode
                    (Elm.Syntax.Expression.FunctionOrValue [] "nvr")
                ]
            )
    }