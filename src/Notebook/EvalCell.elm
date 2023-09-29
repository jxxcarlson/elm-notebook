module Notebook.EvalCell exposing (processCell)

import Dict
import Keyboard
import List.Extra
import Notebook.Cell as Cell exposing (Cell, CellType(..), CellValue(..))
import Notebook.CellHelper
import Notebook.Eval as Eval
import Notebook.Types exposing (EvalState)
import Types exposing (FrontendMsg)


type alias Model =
    Types.FrontendModel


processCell : Int -> Model -> ( Model, Cmd FrontendMsg )
processCell cellIndex model =
    case List.Extra.getAt cellIndex model.currentBook.cells of
        Nothing ->
            ( model, Cmd.none )

        Just cell_ ->
            case cell_.tipe of
                Cell.CTCode ->
                    processCode model cell_

                Cell.CTMarkdown ->
                    processMarkdown model cell_


processMarkdown model cell =
    let
        _ =
            Debug.log "processMarkdown" cell.text

        newCell =
            { cell | value = CVMarkdown cell.text }

        newBook =
            Notebook.CellHelper.updateBookWithCell newCell model.currentBook
    in
    ( { model | currentBook = newBook }, Cmd.none )


processCode model cell_ =
    case String.split "=" cell_.text of
        [] ->
            ( model, Cmd.none )

        expr :: [] ->
            processExpr model expr

        name :: expr :: [] ->
            processNameAndExpr model name expr

        _ ->
            ( { model | pressedKeys = [] }, Cmd.none )


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
