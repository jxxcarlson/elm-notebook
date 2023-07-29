module View.Body exposing (view)

import Dict exposing (Dict)
import Element as E exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font as Font
import LiveBook.Parser
import LiveBook.Types exposing (Book)
import LiveBook.View
import Types exposing (FrontendModel, FrontendMsg)
import UILibrary.Color as Color
import User
import Util
import Value exposing (Value(..))
import View.Button
import View.Geometry
import View.Style


view : FrontendModel -> User.User -> Element FrontendMsg
view model user =
    E.row
        [ E.width (E.px (View.Geometry.appWidth model))
        , E.height (E.px (View.Geometry.bodyHeight model))
        , E.padding 0
        ]
        [ viewNotebook model user
        , E.column [] [ viewNotebookList model user, monitor model ]
        ]


monitor : FrontendModel -> Element FrontendMsg
monitor model =
    E.column
        [ E.padding 12
        , E.spacing 18
        , Font.size 14
        , E.height (E.px monitorHeight)
        , Element.Border.widthEach { left = 1, right = 0, top = 0, bottom = 0 }
        , Element.Border.color Color.darkGray
        , E.scrollbarY
        , Font.color Color.white
        ]
        [ E.row [ Font.size 16, E.spacing 24, E.paddingEach { top = 12, bottom = 0, left = 0, right = 0 } ]
            [ E.el [ Font.underline ] (E.text <| "Monitor") ]
        , notebookControls model
        , E.row [ E.spacing 24 ]
            [ E.text <| "ticks: " ++ String.fromInt model.state.ticks
            , E.text <| "interval: " ++ String.fromFloat model.fastTickInterval
            ]
        , E.row [ E.spacing 24 ]
            [ E.text <| "values: " ++ (List.length model.state.values |> String.fromInt)
            , E.text <| "values to keep: " ++ String.fromInt model.state.valuesToKeep
            ]
        , E.paragraph [] [ E.text <| "probabilities: " ++ (model.state.probabilities |> List.map (\( name, p ) -> name ++ ":" ++ String.fromFloat (Util.roundTo 3 p) |> String.padRight 8 '0') |> String.join ", ") ]
        , E.paragraph [] []
        , E.paragraph [] [ E.text <| "value: " ++ Value.toString (model.state.currentValue |> LiveBook.Parser.roundToFloatValue 3) ]
        , E.paragraph [] [ E.text <| "expr: " ++ model.state.expression ]
        , E.paragraph []
            [ E.text <| "defs: " ++ (model.state.bindings |> String.join "\n ")
            ]
        , E.paragraph [] [ E.text <| "stopExpression: " ++ model.state.stopExpressionString ]
        ]


kVDictToString : Dict String String -> String
kVDictToString dict =
    Dict.foldl (\k v acc -> acc ++ k ++ ": " ++ v ++ "\n") "" dict


valueDictToString : Dict String Value -> String
valueDictToString dict =
    Dict.foldl (\k v acc -> acc ++ k ++ ": " ++ Value.toString v ++ "\n") "" dict


monitorHeight =
    360


viewNotebookList : FrontendModel -> User.User -> Element FrontendMsg
viewNotebookList model user =
    E.column
        [ E.spacing 1
        , E.alignTop
        , Font.size 14
        , E.width (E.px (View.Geometry.notebookListWidth - 46))
        , Element.Border.widthEach { left = 1, right = 0, top = 0, bottom = 1 }
        , Element.Border.color Color.stillDarkerSteelGray
        , Background.color (E.rgb255 73 78 89)
        , E.height (E.px (View.Geometry.bodyHeight model - monitorHeight))
        , E.scrollbarY
        , E.paddingXY 24 12
        ]
        (case model.showNotebooks of
            Types.ShowUserNotebooks ->
                viewMyNotebookList model user

            Types.ShowPublicNotebooks ->
                viewPublicNotebookList model user
        )


notebookControls : FrontendModel -> Element FrontendMsg
notebookControls model =
    E.row [ E.spacing 12, E.paddingEach { top = 0, bottom = 12, left = 0, right = 0 } ]
        [ View.Button.stateEditor
        , View.Button.resetClock
        , View.Button.setClock model
        ]


viewMyNotebookList : FrontendModel -> User.User -> List (Element FrontendMsg)
viewMyNotebookList model user =
    E.el [ Font.color Color.white, E.paddingEach { left = 0, right = 0, bottom = 8, top = 0 } ]
        (E.text <| "Notebooks: " ++ String.fromInt (List.length model.books))
        :: controls model.showNotebooks
        :: List.map (viewNotebookEntry model.currentBook) (List.sortBy (\b -> b.title) model.books)


viewNotebookEntry : Book -> Book -> Element FrontendMsg
viewNotebookEntry currentBook book =
    E.row []
        [ View.Button.viewNotebookEntry currentBook book
        , case book.origin of
            Nothing ->
                E.none

            Just origin ->
                case Util.firstPart origin of
                    Nothing ->
                        E.none

                    Just username ->
                        E.el [ Font.color Color.lightGray, E.paddingXY 0 8, E.width (E.px 80) ] (E.text <| " (" ++ username ++ ")")
        ]


viewPublicNotebookList model user =
    E.el [ Font.color Color.white, E.paddingEach { left = 0, right = 0, bottom = 8, top = 0 } ]
        (E.text <| "Notebooks: " ++ String.fromInt (List.length model.books))
        :: controls model.showNotebooks
        :: List.map (viewPublicNotebookEntry model.currentBook) (List.sortBy (\b -> b.author ++ b.title) model.books)


viewPublicNotebookEntry : Book -> Book -> Element FrontendMsg
viewPublicNotebookEntry currentBook book =
    E.row []
        [ E.el [ Font.color Color.lightGray, E.paddingXY 0 8, E.width (E.px 80) ] (E.text book.author)
        , View.Button.viewNotebookEntry currentBook book
        ]


controls : Types.ShowNotebooks -> Element FrontendMsg
controls showNotebooks =
    E.row [ E.spacing 12 ]
        [ View.Button.myNotebooks showNotebooks
        , E.el [ E.paddingXY 0 8 ] (View.Button.publicNotebooks showNotebooks)
        ]


viewNotebook : FrontendModel -> User.User -> Element FrontendMsg
viewNotebook model user =
    let
        viewData =
            { book = model.currentBook
            , kvDict = model.kvDict
            , width = View.Geometry.notebookWidth model
            , ticks = model.tickCount
            }
    in
    E.column
        [ E.paddingEach { left = 24, right = 24, top = 0, bottom = 0 }
        --, E.spacing 18
        ]
        [ E.column
            [ View.Style.fgGray 0.6
            , Font.size 14
            , E.height (E.px (View.Geometry.bodyHeight model))
            , E.width (E.px (View.Geometry.notebookWidth model))
            , E.scrollbarY
            , E.clipX
          --  , E.spacing 24
           -- , E.paddingEach { top = 19, bottom = 48, left = 0, right = 0 }
            ]
            (List.map
                (LiveBook.View.view viewData model.cellContent)
                model.currentBook.cells
            )
        ]
