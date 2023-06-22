module View.Button exposing
    ( adminPopup
    , dismissPopup
    , dismissPopupSmall
    , editTitle
    , newNotebook
    , runTask
    , setUpUser
    , signIn
    , signOut
    , signUp
    , viewNotebookEntry
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



-- CELL
-- POPUP


dismissPopupTransparent : Element FrontendMsg
dismissPopupTransparent =
    Button.largePrimary { msg = ChangePopup NoPopup, status = Button.ActiveTransparent, label = Button.Text "x", tooltipText = Nothing }


dismissPopupSmall : Element FrontendMsg
dismissPopupSmall =
    Button.smallPrimary { msg = ChangePopup NoPopup, status = Button.ActiveTransparent, label = Button.Text "x", tooltipText = Nothing }


dismissPopup : Element FrontendMsg
dismissPopup =
    Button.largePrimary { msg = ChangePopup NoPopup, status = Button.Active, label = Button.Text "x", tooltipText = Nothing }


editTitle : Types.AppMode -> Element FrontendMsg
editTitle mode =
    if mode == Types.AMEditTitle then
        Button.smallPrimary { msg = UpdateNotebookTitle, status = Button.Active, label = Button.Text "Save Notebook", tooltipText = Nothing }

    else
        Button.smallPrimary { msg = ChangeAppMode Types.AMEditTitle, status = Button.Active, label = Button.Text "Edit Title", tooltipText = Nothing }


newNotebook : Element FrontendMsg
newNotebook =
    Button.smallPrimary { msg = NewNotebook, status = Button.Active, label = Button.Text "New Notebook", tooltipText = Nothing }


viewNotebookEntry : Types.Book -> Types.Book -> Element FrontendMsg
viewNotebookEntry currentBook book =
    if currentBook.id == book.id then
        Button.smallPrimary { msg = NoOpFrontendMsg, status = Button.Active, label = Button.Text book.title, tooltipText = Nothing }

    else
        Button.smallPrimary { msg = SetCurrentNotebook book, status = Button.ActiveTransparent, label = Button.Text book.title, tooltipText = Nothing }



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
