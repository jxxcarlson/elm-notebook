module View.Button exposing
    ( adminPopup
    , dismissPopup
    , dismissPopupSmall
    , runTask
    , setUpUser
    , signIn
    , signOut
    , signUp
    )

import Config
import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Types exposing (..)
import UILibrary.Button as Button
import UILibrary.Color as Color
import View.Style
import View.Utility



-- TEMPLATES


buttonTemplate : List (E.Attribute msg) -> msg -> String -> Element msg
buttonTemplate attrList msg label_ =
    E.row ([ View.Style.bgGray 0.2, E.pointer, E.mouseDown [ Background.color Color.darkRed ] ] ++ attrList)
        [ Input.button View.Style.buttonStyle
            { onPress = Just msg
            , label = E.el [ E.centerX, E.centerY, Font.size 14 ] (E.text label_)
            }
        ]


linkTemplate : msg -> E.Color -> String -> Element msg
linkTemplate msg fontColor label_ =
    E.row [ E.pointer, E.mouseDown [ Background.color Color.paleBlue ] ]
        [ Input.button linkStyle
            { onPress = Just msg
            , label = E.el [ E.centerX, E.centerY, Font.size 14, Font.color fontColor ] (E.text label_)
            }
        ]


linkStyle =
    [ Font.color (E.rgb255 255 255 255)
    , E.paddingXY 8 2
    ]



-- IMAGE


dismissPopupTransparent : Element FrontendMsg
dismissPopupTransparent =
    Button.largePrimary { msg = ChangePopup NoPopup, status = Button.ActiveTransparent, label = Button.Text "x", tooltipText = Nothing }


dismissPopupSmall : Element FrontendMsg
dismissPopupSmall =
    Button.smallPrimary { msg = ChangePopup NoPopup, status = Button.ActiveTransparent, label = Button.Text "x", tooltipText = Nothing }


dismissPopup : Element FrontendMsg
dismissPopup =
    Button.largePrimary { msg = ChangePopup NoPopup, status = Button.Active, label = Button.Text "x", tooltipText = Nothing }



-- USER


signOut username =
    buttonTemplate [] SignOut ("Sign out " ++ username)


signIn : Element FrontendMsg
signIn =
    buttonTemplate [] SignIn "Sign in"


signUp : Element FrontendMsg
signUp =
    buttonTemplate [] (ChangePopup SignUpPopup) "Sign up"


setUpUser : Element FrontendMsg
setUpUser =
    buttonTemplate [] SignUp "Submit"



-- ADMIN


adminPopup : FrontendModel -> Element FrontendMsg
adminPopup model =
    buttonTemplate [] (ChangePopup AdminPopup) "Admin"


runTask : Element FrontendMsg
runTask =
    buttonTemplate [] AdminRunTask "Run backend task"
