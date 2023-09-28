module Notebook.EvalCell exposing (..)

import Dict
import Keyboard
import Notebook.Eval as Eval
import Notebook.Types exposing (EvalState, Model, Msg(..))


processCell : Model -> List Keyboard.Key -> ( Model, Cmd Msg )
processCell model pressedKeys =
    if List.member Keyboard.Shift pressedKeys && List.member Keyboard.Enter pressedKeys then
        case String.split "=" model.expressionText of
            [] ->
                ( model, Cmd.none )

            expr :: [] ->
                processExpr model expr

            name :: expr :: [] ->
                processNameAndExpr model name expr

            _ ->
                ( { model | pressedKeys = pressedKeys }, Cmd.none )

    else
        ( { model | pressedKeys = pressedKeys }, Cmd.none )


processExpr : Model -> String -> ( Model, Cmd Msg )
processExpr model expr =
    if String.left 6 expr == ":clear" then
        let
            evalState =
                model.evalState
        in
        ( { model
            | replData = Just { name = Nothing, value = "cleared ...", tipe = "" }
            , evalState = { evalState | decls = Dict.empty }
          }
        , Cmd.none
        )

    else if String.left 7 expr == ":remove" then
        let
            key =
                String.dropLeft 8 expr |> String.trim
        in
        case Dict.get key model.evalState.decls of
            Just _ ->
                ( { model
                    | replData = Just { name = Nothing, value = key ++ ": removed", tipe = "" }
                    , evalState = Eval.removeDeclaration key model.evalState
                  }
                , Cmd.none
                )

            Nothing ->
                ( { model | replData = Just { name = Nothing, value = key ++ ": not found", tipe = "" } }, Cmd.none )

    else
        ( { model | replData = Nothing }, Eval.requestEvaluation model.evalState expr )


processNameAndExpr : Model -> String -> String -> ( Model, Cmd Msg )
processNameAndExpr model name expr =
    let
        newEvalState =
            Eval.insertDeclaration name (name ++ " = " ++ expr ++ "\n") model.evalState

        replData =
            Just { name = Nothing, value = "Ok", tipe = "" }
    in
    ( { model | replData = replData, evalState = newEvalState }, Cmd.none )
