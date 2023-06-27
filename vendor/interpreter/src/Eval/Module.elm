module Eval.Module exposing (eval, trace)

import Core
import Elm.Parser
import Elm.Processing
import Elm.Syntax.Declaration exposing (Declaration(..))
import Elm.Syntax.Expression exposing (Expression)
import Elm.Syntax.File exposing (File)
import Elm.Syntax.Module exposing (Module(..))
import Elm.Syntax.ModuleName exposing (ModuleName)
import Elm.Syntax.Node as Node exposing (Node(..))
import Environment
import Eval.Expression
import Eval.Log as Log
import Eval.Types as Types exposing (CallTree, CallTreeContinuation(..), Error(..))
import FastDict as Dict
import Maybe.Extra
import Result.MyExtra
import Rope exposing (Rope)
import Syntax exposing (fakeNode)
import Value exposing (Env, Value, unsupported)


eval : String -> Expression -> Result Error Value
eval source expression =
    let
        ( result, _, _ ) =
            traceOrEvalModule { trace = False } source expression

        --|> Debug.log "@@EVAL"
        --_ =
        --    case result of
        --        Ok value ->
        --            "@@@: EVAL, VALUE: " ++ Debug.toString value
        --
        --        Err err ->
        --            "@@@: EVAL, ERROR: " ++ Debug.toString err
    in
    result


trace : String -> Expression -> ( Result Error Value, Rope CallTree, Rope Log.Line )
trace source expression =
    traceOrEvalModule { trace = True } source expression



--
--
--Example 2:
--
--a = 1
--a
--
--
--
-- main =
--            Maybe.andThen (Dict.get [ "Main" ]) functions
--                |> Maybe.andThen (Dict.get "main")
--                |> Maybe.map (.expression >> Node.value)
--                |> Debug.log "@@@MAIN"
--
--Just (
--  LetExpression {
--     declarations = [
--       Node { end = { column = 10, row = 5 }, start = { column = 5, row = 5 } } (LetFunction
--           { declaration = Node { end = { column = 10, row = 5 }, start = { column = 5, row = 5 } }
--                  { arguments = []
--                  , expression = Node { end = { column = 10, row = 5 }, start = { column = 9, row = 5 } } (Integer 1)
--                  , name = Node { end = { column = 6, row = 5 }, start = { column = 5, row = 5 } } "a"
--                  }
--           , documentation = Nothing
--           , signature = Nothing
--       }
--
--       )
--       ]
--    , expression = Node { end = { column = 6, row = 7 }, start = { column = 5, row = 7 } } (FunctionOrValue [] "a")
--     }
--  )


traceOrEvalModule : { trace : Bool } -> String -> Expression -> ( Result Error Value, Rope CallTree, Rope Log.Line )
traceOrEvalModule cfg source expression =
    let
        maybeEnv : Result Error Env
        maybeEnv =
            source
                |> Elm.Parser.parse
                |> Result.mapError ParsingError
                |> Result.map
                    (\rawFile ->
                        let
                            context : Elm.Processing.ProcessContext
                            context =
                                Elm.Processing.init
                        in
                        Elm.Processing.process context rawFile
                    )
                |> Result.andThen buildInitialEnv

        --|> Debug.log "@@MAYBE_ENV"
        mEnv =
            Result.toMaybe maybeEnv

        values =
            Maybe.map .values mEnv

        --|> Debug.log "@@@VALUES"
        moduleNames =
            Maybe.map (.functions >> Dict.keys) mEnv

        -- |> Debug.log "@@@KEYS"
        functions =
            Maybe.map .functions mEnv

        main =
            Maybe.andThen (Dict.get [ "Main" ]) functions

        --|> Maybe.andThen (Dict.get "main")
        --|> Maybe.map (.expression >> Node.value)
        --|> Debug.log "@@@MAIN"
    in
    case maybeEnv of
        Err e ->
            ( Err e, Rope.empty, Rope.empty )

        Ok env ->
            let
                callTreeContinuation : CallTreeContinuation
                callTreeContinuation =
                    CTCRoot

                ( result, callTrees, logLines ) =
                    Eval.Expression.evalExpression
                        (fakeNode expression)
                        { trace = cfg.trace
                        , callTreeContinuation = callTreeContinuation
                        , logContinuation = Log.Done
                        }
                        env
            in
            ( Result.mapError Types.EvalError result
            , callTrees
            , logLines
            )


buildInitialEnv : File -> Result Error Env
buildInitialEnv file =
    let
        moduleName : ModuleName
        moduleName =
            case Node.value file.moduleDefinition of
                NormalModule normal ->
                    Node.value normal.moduleName

                PortModule port_ ->
                    Node.value port_.moduleName

                EffectModule effect ->
                    Node.value effect.moduleName

        coreEnv : Env
        coreEnv =
            { currentModule = moduleName
            , callStack = []
            , functions = Core.functions
            , values = Dict.empty
            }

        addDeclaration : Node Declaration -> Env -> Result Error Env
        addDeclaration (Node _ decl) env =
            case decl of
                FunctionDeclaration function ->
                    let
                        (Node _ implementation) =
                            function.declaration
                    in
                    Ok (Environment.addFunction moduleName implementation env)

                PortDeclaration _ ->
                    Err <| Types.EvalError <| unsupported env "Port declaration"

                InfixDeclaration _ ->
                    Err <| Types.EvalError <| unsupported env "Infix declaration"

                Destructuring _ _ ->
                    Err <| Types.EvalError <| unsupported env "Top level destructuring"

                AliasDeclaration _ ->
                    Ok env

                CustomTypeDeclaration _ ->
                    Ok env
    in
    file.declarations
        |> Result.MyExtra.combineFoldl
            addDeclaration
            (Ok coreEnv)
