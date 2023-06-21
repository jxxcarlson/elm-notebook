module Core exposing (functions, operators)

{-| 
@docs functions, operators
-}


import Core.Array
import Core.Basics
import Core.Bitwise
import Core.Char
import Core.Debug
import Core.Dict
import Core.Elm.JsArray
import Core.Elm.Kernel.List
import Core.Elm.Kernel.String
import Core.List
import Core.Maybe
import Core.Platform
import Core.Platform.Cmd
import Core.Platform.Sub
import Core.Process
import Core.Result
import Core.Set
import Core.String
import Core.Tuple
import Elm.Syntax.Expression
import Elm.Syntax.ModuleName
import Elm.Syntax.Pattern
import FastDict


functions :
    FastDict.Dict Elm.Syntax.ModuleName.ModuleName (FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation)
functions =
    FastDict.fromList
        [ ( [ "Bitwise" ], Core.Bitwise.functions )
        , ( [ "Array" ], Core.Array.functions )
        , ( [ "Platform", "Sub" ], Core.Platform.Sub.functions )
        , ( [ "Platform", "Cmd" ], Core.Platform.Cmd.functions )
        , ( [ "Debug" ], Core.Debug.functions )
        , ( [ "List" ], Core.List.functions )
        , ( [ "Tuple" ], Core.Tuple.functions )
        , ( [ "Elm", "JsArray" ], Core.Elm.JsArray.functions )
        , ( [ "Result" ], Core.Result.functions )
        , ( [ "Platform" ], Core.Platform.functions )
        , ( [ "Set" ], Core.Set.functions )
        , ( [ "String" ], Core.String.functions )
        , ( [ "Dict" ], Core.Dict.functions )
        , ( [ "Maybe" ], Core.Maybe.functions )
        , ( [ "Char" ], Core.Char.functions )
        , ( [ "Process" ], Core.Process.functions )
        , ( [ "Basics" ], Core.Basics.functions )
        , ( [ "Elm", "Kernel", "List" ], Core.Elm.Kernel.List.functions )
        , ( [ "Elm", "Kernel", "String" ], Core.Elm.Kernel.String.functions )
        ]


operators : FastDict.Dict String Elm.Syntax.Pattern.QualifiedNameRef
operators =
    FastDict.fromList
        (List.concat [ Core.List.operators, Core.Basics.operators ])