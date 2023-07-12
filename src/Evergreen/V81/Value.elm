module Evergreen.V81.Value exposing (..)

import Array
import Elm.Syntax.Expression
import Elm.Syntax.ModuleName
import Elm.Syntax.Node
import Elm.Syntax.Pattern
import Evergreen.V81.FastDict


type alias EnvValues =
    Evergreen.V81.FastDict.Dict String Value


type alias Env =
    { currentModule : Elm.Syntax.ModuleName.ModuleName
    , functions : Evergreen.V81.FastDict.Dict Elm.Syntax.ModuleName.ModuleName (Evergreen.V81.FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation)
    , values : EnvValues
    , callStack : List Elm.Syntax.Pattern.QualifiedNameRef
    }


type Value
    = String String
    | Int Int
    | Float Float
    | Char Char
    | Bool Bool
    | Unit
    | Tuple Value Value
    | Triple Value Value Value
    | Record (Evergreen.V81.FastDict.Dict String Value)
    | Custom Elm.Syntax.Pattern.QualifiedNameRef (List Value)
    | PartiallyApplied Env (List Value) (List (Elm.Syntax.Node.Node Elm.Syntax.Pattern.Pattern)) (Maybe Elm.Syntax.Pattern.QualifiedNameRef) (Elm.Syntax.Node.Node Elm.Syntax.Expression.Expression)
    | JsArray (Array.Array Value)
    | List (List Value)
