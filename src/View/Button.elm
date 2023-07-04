module View.Button exposing
    ( adminPopup
    , cancelDeleteNotebook
    , clearValues
    , cloneNotebook
    , createDataSet
    , deleteDataSet
    , deleteNotebook
    , dismissPopup
    , dismissPopupSmall
    , editDataSet
    , editTitle
    , lockCell
    , manual
    , manualLarge
    , myNotebooks
    , newDataSet
    , newNotebook
    , public
    , publicNotebooks
    , pullNotebook
    , runTask
    , saveDataSetAsPrivate
    , saveDataSetAsPublic
    , setUpUser
    , signIn
    , signOut
    , signUp
    , toggleViewPrivateDataSets
    , toggleViewPublicDataSets
    , viewNotebookEntry
    )

import Config
import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import LiveBook.DataSet
import LiveBook.Types exposing (Book)
import Types exposing (..)
import UILibrary.Button as Button
import UILibrary.Color as Color
import View.Style



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


clearValues : Element FrontendMsg
clearValues =
    Button.smallPrimary { msg = ClearNotebookValues, status = Button.Active, label = Button.Text "Clear Values", tooltipText = Nothing }


myNotebooks : Types.ShowNotebooks -> Element FrontendMsg
myNotebooks showNotebooks =
    case showNotebooks of
        ShowUserNotebooks ->
            Button.smallPrimary { msg = NoOpFrontendMsg, status = Button.Highlighted, label = Button.Text "Mine", tooltipText = Nothing }

        ShowPublicNotebooks ->
            Button.smallPrimary { msg = SetShowNotebooksState Types.ShowUserNotebooks, status = Button.Active, label = Button.Text "Mine", tooltipText = Nothing }


publicNotebooks : Types.ShowNotebooks -> Element FrontendMsg
publicNotebooks showNotebooks =
    case showNotebooks of
        ShowUserNotebooks ->
            Button.smallPrimary { msg = SetShowNotebooksState Types.ShowPublicNotebooks, status = Button.Active, label = Button.Text "Public", tooltipText = Nothing }

        ShowPublicNotebooks ->
            Button.smallPrimary { msg = NoOpFrontendMsg, status = Button.Highlighted, label = Button.Text "Public", tooltipText = Nothing }


cancelDeleteNotebook : DeleteNotebookState -> Element FrontendMsg
cancelDeleteNotebook deleteNotebookState =
    case deleteNotebookState of
        CanDeleteNotebook ->
            Button.smallPrimary { msg = CancelDeleteNotebook, status = Button.Highlighted, label = Button.Text "Cancel", tooltipText = Nothing }

        WaitingToDeleteNotebook ->
            E.none


deleteNotebook : DeleteNotebookState -> Element FrontendMsg
deleteNotebook deleteNotebookState =
    case deleteNotebookState of
        WaitingToDeleteNotebook ->
            Button.smallPrimary { msg = ProposeDeletingNotebook, status = Button.Active, label = Button.Text "Delete Notebook", tooltipText = Nothing }

        CanDeleteNotebook ->
            Button.smallPrimary { msg = ProposeDeletingNotebook, status = Button.Highlighted, label = Button.Text "Delete Notebook", tooltipText = Nothing }


public : Book -> Element FrontendMsg
public book =
    if book.public then
        Button.smallPrimary { msg = TogglePublic, status = Button.Active, label = Button.Text "Public", tooltipText = Nothing }

    else
        Button.smallPrimary { msg = TogglePublic, status = Button.Active, label = Button.Text "Private", tooltipText = Nothing }


viewNotebookEntry : Book -> Book -> Element FrontendMsg
viewNotebookEntry currentBook book =
    if currentBook.id == book.id then
        if book.public then
            Button.smallPrimary { msg = NoOpFrontendMsg, status = Button.HighlightedSpecial, label = Button.Text book.title, tooltipText = Nothing }

        else
            Button.smallPrimary { msg = NoOpFrontendMsg, status = Button.Highlighted, label = Button.Text book.title, tooltipText = Nothing }

    else if book.public then
        Button.smallPrimary { msg = SetCurrentNotebook book, status = Button.ActiveTransparentSpecial, label = Button.Text book.title, tooltipText = Nothing }

    else
        Button.smallPrimary { msg = SetCurrentNotebook book, status = Button.ActiveTransparent, label = Button.Text book.title, tooltipText = Nothing }


cloneNotebook : Element FrontendMsg
cloneNotebook =
    Button.smallPrimary { msg = CloneNotebook, status = Button.Active, label = Button.Text "Clone", tooltipText = Nothing }


pullNotebook : Element FrontendMsg
pullNotebook =
    Button.smallPrimary { msg = PullNotebook, status = Button.Active, label = Button.Text "Update", tooltipText = Nothing }


manual : Element FrontendMsg
manual =
    Button.smallPrimary { msg = ChangePopup ManualPopup, status = Button.Active, label = Button.Text "Manual", tooltipText = Nothing }


manualLarge : Element FrontendMsg
manualLarge =
    Button.largePrimary { msg = ChangePopup ManualPopup, status = Button.Active, label = Button.Text "Manual", tooltipText = Nothing }


newDataSet : Element FrontendMsg
newDataSet =
    Button.largePrimary { msg = ChangePopup NewDataSetPopup, status = Button.Active, label = Button.Text "New Data Set", tooltipText = Nothing }


editDataSet : LiveBook.DataSet.DataSetMetaData -> Element FrontendMsg
editDataSet dataSetDescripion =
    Button.smallPrimary { msg = ChangePopup (EditDataSetPopup dataSetDescripion), status = Button.Active, label = Button.Text "Edit", tooltipText = Nothing }


lockCell : LiveBook.Types.Cell -> Element FrontendMsg
lockCell cell =
    case cell.locked of
        True ->
            Button.smallPrimary { msg = ToggleCellLock cell, status = Button.Active, label = Button.Text "Locked", tooltipText = Nothing }

        False ->
            Button.smallPrimary { msg = ToggleCellLock cell, status = Button.Active, label = Button.Text "Open", tooltipText = Nothing }


saveDataSetAsPublic : LiveBook.DataSet.DataSetMetaData -> Element FrontendMsg
saveDataSetAsPublic dataSetMeta =
    Button.largePrimary { msg = AskToSaveDataSet { dataSetMeta | public = True }, status = Button.Active, label = Button.Text "Save as public", tooltipText = Nothing }


saveDataSetAsPrivate : LiveBook.DataSet.DataSetMetaData -> Element FrontendMsg
saveDataSetAsPrivate dataSetMeta =
    Button.largePrimary { msg = AskToSaveDataSet { dataSetMeta | public = False }, status = Button.Active, label = Button.Text "Save as private", tooltipText = Nothing }


deleteDataSet : LiveBook.DataSet.DataSetMetaData -> Element FrontendMsg
deleteDataSet dataSetMeta =
    Button.largePrimary { msg = AskToDeleteDataSet dataSetMeta, status = Button.Active, label = Button.Text "Delete", tooltipText = Nothing }


createDataSet : Element FrontendMsg
createDataSet =
    Button.largePrimary { msg = AskToCreateDataSet, status = Button.Active, label = Button.Text "Create", tooltipText = Nothing }


toggleViewPublicDataSets : Element FrontendMsg
toggleViewPublicDataSets =
    Button.largePrimary { msg = ChangePopup ViewPublicDataSetsPopup, status = Button.Active, label = Button.Text "Public Datasets", tooltipText = Nothing }


toggleViewPrivateDataSets : Element FrontendMsg
toggleViewPrivateDataSets =
    Button.largePrimary { msg = ChangePopup ViewPrivateDataSetsPopup, status = Button.Active, label = Button.Text "My Datasets", tooltipText = Nothing }


newNotebook : Element FrontendMsg
newNotebook =
    Button.smallPrimary { msg = NewNotebook, status = Button.Active, label = Button.Text "New Notebook", tooltipText = Nothing }



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
    buttonTemplate [] AdminRunTask "RBT"
