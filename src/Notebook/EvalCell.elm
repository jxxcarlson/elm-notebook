module Notebook.EvalCell exposing (processCell)

import Dict
import Keyboard
import List.Extra
import LiveBook.Types exposing (Cell)
import Notebook.Eval as Eval
import Notebook.Types exposing (EvalState)
import Types exposing (FrontendMsg)


type alias Model =
    Types.FrontendModel



-- evalCell : Int -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )


processCell : Int -> List Keyboard.Key -> Model -> ( Model, Cmd FrontendMsg )
processCell cellIndex pressedKeys model =
    case List.Extra.getAt cellIndex model.currentBook.cells of
        Nothing ->
            ( model, Cmd.none )

        Just cell_ ->
            let
                filteredText =
                    List.filter (\line -> List.member (String.left 1 line) [ ">", ":" ]) cell_.text
                        |> String.join "\n"
                        |> String.dropLeft 1
                        |> String.trim
            in
            case String.split "=" filteredText of
                [] ->
                    ( model, Cmd.none )

                expr :: [] ->
                    processExpr model expr

                name :: expr :: [] ->
                    processNameAndExpr model name expr

                _ ->
                    ( { model | pressedKeys = pressedKeys }, Cmd.none )


processExpr : Model -> String -> ( Model, Cmd FrontendMsg )
processExpr model expr =
    if String.left 6 expr == ":clear" then
        processClearCmd model

    else if String.left 7 expr == ":remove" then
        processRemoveCmd model expr

    else
        ( { model | replData = Nothing }, Eval.requestEvaluation model.evalState expr )


processClearCmd model =
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


processRemoveCmd : Model -> String -> ( Model, Cmd FrontendMsg )
processRemoveCmd model expr =
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


processNameAndExpr : Model -> String -> String -> ( Model, Cmd FrontendMsg )
processNameAndExpr model name expr =
    let
        newEvalState =
            Eval.insertDeclaration name (name ++ " = " ++ expr ++ "\n") model.evalState

        replData =
            Just { name = Nothing, value = "Ok", tipe = "" }
    in
    ( { model | replData = replData, evalState = newEvalState }, Cmd.none )
