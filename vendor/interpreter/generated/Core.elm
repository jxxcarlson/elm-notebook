module Core exposing (functions, operators)

{-| 
@docs operators, functions
-}


import Core.Elm.Kernel.String
import Elm.Syntax.Expression
import Elm.Syntax.ModuleName
import Elm.Syntax.Pattern
import FastDict


functions :
    FastDict.Dict Elm.Syntax.ModuleName.ModuleName (FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation)
functions =
    FastDict.fromList
        [ ( [ "Elm", "Kernel", "String" ], Core.Elm.Kernel.String.functions ) ]


operators : FastDict.Dict String Elm.Syntax.Pattern.QualifiedNameRef
operators =
    FastDict.fromList (List.concat [])


