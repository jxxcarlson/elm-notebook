module View.Utility exposing
    ( cssNode
    , elementAttribute
    , getElementWithViewPort
    , hideIf
    , katexCSS
    , noFocus
    , setViewPortForSelectedLine
    , showIf
    , showIfIsAdmin
    , showIfIsUserIsUnlocked
    )

import Browser.Dom as Dom
import Element exposing (Element)
import Html
import Html.Attributes as HA
import Task exposing (Task)
import Types exposing (FrontendModel, FrontendMsg)



-- import Types exposing (FrontendModel, FrontendMsg)


showIfIsAdmin : FrontendModel -> Element msg -> Element msg
showIfIsAdmin model element =
    showIf (Maybe.map .username model.currentUser == Just "jxxcarlson") element


showIfIsUserIsUnlocked : FrontendModel -> Element msg -> Element msg
showIfIsUserIsUnlocked model element =
    showIf (Maybe.map .locked model.currentUser == Just False) element


showIf : Bool -> Element msg -> Element msg
showIf isVisible element =
    if isVisible then
        element

    else
        Element.none


hideIf : Bool -> Element msg -> Element msg
hideIf condition element =
    if condition then
        Element.none

    else
        element


setViewPortForSelectedLine : Dom.Element -> Dom.Viewport -> Cmd FrontendMsg
setViewPortForSelectedLine element viewport =
    let
        y =
            viewport.viewport.y + element.element.y - element.element.height - 100
    in
    Task.attempt (\_ -> Types.NoOpFrontendMsg) (Dom.setViewportOf "__RENDERED_TEXT__" 0 y)


getElementWithViewPort : Dom.Viewport -> String -> Task Dom.Error ( Dom.Element, Dom.Viewport )
getElementWithViewPort vp id =
    Dom.getElement id
        |> Task.map (\el -> ( el, vp ))


noFocus : Element.FocusStyle
noFocus =
    { borderColor = Nothing
    , backgroundColor = Nothing
    , shadow = Nothing
    }


cssNode : String -> Element FrontendMsg
cssNode fileName =
    Html.node "link" [ HA.rel "stylesheet", HA.href fileName ] [] |> Element.html



-- Include KaTeX CSS


katexCSS : Element FrontendMsg
katexCSS =
    Element.html <|
        Html.node "link"
            [ HA.attribute "rel" "stylesheet"
            , HA.attribute "href" "https://cdn.jsdelivr.net/npm/katex@0.12.0/dist/katex.min.css"
            ]
            []


elementAttribute : String -> String -> Element.Attribute msg
elementAttribute key value =
    Element.htmlAttribute (HA.attribute key value)
