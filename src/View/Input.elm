module View.Input exposing
    ( author
    , cloneReference
    , comments
    , data
    , description
    , email
    , identifier
    , initialStateValue
    , name
    , password
    , passwordAgain
    , signupUsername
    , stateBindings
    , stateExpr
    , title
    , username
    )

import Element as E exposing (Element, px)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Types exposing (FrontendModel, FrontendMsg(..))
import View.Color


multiLineTemplate : Int -> Int -> String -> (String -> msg) -> String -> Element msg
multiLineTemplate width_ height_ default msg text =
    Input.multiline [ E.moveUp 5, Font.size 16, E.width (E.px width_), E.height (E.px height_) ]
        { onChange = msg
        , text = text
        , label = Input.labelHidden default
        , placeholder = Just <| Input.placeholder [ E.moveUp 5 ] (E.text default)
        , spellcheck = False
        }


inputFieldTemplate2 : List (E.Attr () msg) -> E.Length -> String -> (String -> msg) -> String -> Element msg
inputFieldTemplate2 attr width_ default msg text =
    Input.text ([ E.moveUp 5, Font.size 16, E.height (px 33), E.width width_ ] ++ attr)
        { onChange = msg
        , text = text
        , label = Input.labelHidden default
        , placeholder = Just <| Input.placeholder [ E.moveUp 6 ] (E.text default)
        }


initialStateValue model =
    inputFieldTemplate (E.px 300) "Initial Value" InputInitialStateValue model.inputInitialStateValue


name model =
    inputFieldTemplate (E.px 300) "Name" InputName model.inputName


identifier model =
    inputFieldTemplate (E.px 300) "Identifier" InputIdentifier model.inputIdentifier


author model =
    inputFieldTemplate (E.px 300) "Author" InputAuthor model.inputAuthor


stateExpr model =
    multiLineTemplate 500 80 "Expression" InputStateExpression model.inputStateExpression


stateBindings model =
    multiLineTemplate 500 80 "Definitions" InputStateBindings model.inputStateBindings


description model =
    multiLineTemplate 500 80 "Description" InputDescription model.inputDescription


comments model =
    multiLineTemplate 500 80 "Comments" InputComments model.inputComments


data model =
    multiLineTemplate 500 200 "Data" InputData model.inputData



-- SIGN IN, UP, OUT


inputFieldTemplate : E.Length -> String -> (String -> msg) -> String -> Element msg
inputFieldTemplate width_ default msg text =
    Input.text
        [ E.moveUp 5
        , Font.size 16
        , E.height (px 33)
        , E.width width_
        , Font.color View.Color.white
        , Background.color View.Color.medGray
        ]
        { onChange = msg
        , text = text
        , label = Input.labelHidden default
        , placeholder = Just <| Input.placeholder [ E.moveUp 5 ] (E.el [ Font.color View.Color.white ] (E.text default))
        }


passwordTemplate : E.Length -> String -> (String -> msg) -> String -> Element msg
passwordTemplate width_ default msg text =
    Input.currentPassword
        [ E.moveUp 5
        , Font.size 14
        , E.height (px 33)
        , E.width width_
        , Font.color View.Color.white
        , Background.color View.Color.medGray
        ]
        { onChange = msg
        , text = text
        , label = Input.labelHidden default
        , placeholder = Just <| Input.placeholder [ E.moveUp 5 ] (E.el [ Font.color View.Color.white ] (E.text default))
        , show = False
        }


username model =
    inputFieldTemplate (E.px 220) "Username" InputUsername model.inputUsername


signupUsername model =
    inputFieldTemplate (E.px 220) "Username" InputSignupUsername model.inputSignupUsername


email model =
    inputFieldTemplate (E.px 220) "Email" InputEmail model.inputEmail


cloneReference model =
    inputFieldTemplate2 [ Font.size 14, E.height (E.px 28) ] (E.px 180) "Notebook identifier" InputCloneReference model.cloneReference



--inputFieldTemplate2 : List (E.Attr () msg) -> E.Length -> String -> (String -> msg) -> String -> Element msg
--inputFieldTemplate2 attr width_ default msg text


password model =
    passwordTemplate (E.px 220) "Password" InputPassword model.inputPassword


passwordAgain model =
    passwordTemplate (E.px 220) "Password again" InputPasswordAgain model.inputPasswordAgain


title model =
    inputFieldTemplate (E.px 220) "Title" InputTitle model.inputTitle
