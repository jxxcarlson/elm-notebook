module Evergreen.Migrate.V30 exposing (..)

{-| This migration file was automatically generated by the lamdera compiler.

It includes:

  - A migration for each of the 6 Lamdera core types that has changed
  - A function named `migrate_ModuleName_TypeName` for each changed/custom type

Expect to see:

  - `Unimplementеd` values as placeholders wherever I was unable to figure out a clear migration path for you
  - `@NOTICE` comments for things you should know about, i.e. new custom type constructors that won't get any
    value mappings from the old type by default

You can edit this file however you wish! It won't be generated again.

See <https://dashboard.lamdera.com/docs/evergreen> for more info.

-}

import Evergreen.V20.LiveBook.DataSet
import Evergreen.V20.LiveBook.Types
import Evergreen.V20.Types
import Evergreen.V20.User
import Evergreen.V30.LiveBook.DataSet
import Evergreen.V30.LiveBook.Types
import Evergreen.V30.Types
import Evergreen.V30.User
import Lamdera.Migrations exposing (..)
import List


frontendModel : Evergreen.V20.Types.FrontendModel -> ModelMigration Evergreen.V30.Types.FrontendModel Evergreen.V30.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V20.Types.BackendModel -> ModelMigration Evergreen.V30.Types.BackendModel Evergreen.V30.Types.BackendMsg
backendModel old =
    ModelUnchanged


frontendMsg : Evergreen.V20.Types.FrontendMsg -> MsgMigration Evergreen.V30.Types.FrontendMsg Evergreen.V30.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V20.Types.ToBackend -> MsgMigration Evergreen.V30.Types.ToBackend Evergreen.V30.Types.BackendMsg
toBackend old =
    MsgMigrated ( migrate_Types_ToBackend old, Cmd.none )


backendMsg : Evergreen.V20.Types.BackendMsg -> MsgMigration Evergreen.V30.Types.BackendMsg Evergreen.V30.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V20.Types.ToFrontend -> MsgMigration Evergreen.V30.Types.ToFrontend Evergreen.V30.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_FrontendModel : Evergreen.V20.Types.FrontendModel -> Evergreen.V30.Types.FrontendModel
migrate_Types_FrontendModel old =
    { key = old.key
    , url = old.url
    , message = old.message
    , messages = old.messages |> List.map migrate_Types_Message
    , appState = old.appState |> migrate_Types_AppState
    , appMode = old.appMode |> migrate_Types_AppMode
    , currentTime = old.currentTime
    , pressedKeys = old.pressedKeys
    , users = old.users
    , inputName = old.inputName
    , inputAuthor = old.inputAuthor
    , inputDescription = old.inputDescription
    , inputComments = old.inputComments
    , inputData = old.inputData
    , dataSetMetaDataList = []
    , kvDict = old.kvDict
    , books = old.books |> List.map migrate_LiveBook_Types_Book
    , currentBook = old.currentBook |> migrate_LiveBook_Types_Book
    , cellContent = old.cellContent
    , currentCellIndex = old.currentCellIndex
    , cloneReference = old.cloneReference
    , deleteNotebookState = old.deleteNotebookState |> migrate_Types_DeleteNotebookState
    , showNotebooks = old.showNotebooks |> migrate_Types_ShowNotebooks
    , signupState = old.signupState |> migrate_Types_SignupState
    , currentUser = old.currentUser
    , inputUsername = old.inputUsername
    , inputSignupUsername = old.inputSignupUsername
    , inputEmail = old.inputEmail
    , inputRealname = old.inputRealname
    , inputPassword = old.inputPassword
    , inputPasswordAgain = old.inputPasswordAgain
    , inputTitle = old.inputTitle
    , windowWidth = old.windowWidth
    , windowHeight = old.windowHeight
    , popupState = old.popupState |> migrate_Types_PopupState
    , showEditor = old.showEditor
    }


migrate_LiveBook_DataSet_DataSet : Evergreen.V20.LiveBook.DataSet.DataSet -> Evergreen.V30.LiveBook.DataSet.DataSet
migrate_LiveBook_DataSet_DataSet old =
    old


migrate_LiveBook_Types_Book : Evergreen.V20.LiveBook.Types.Book -> Evergreen.V30.LiveBook.Types.Book
migrate_LiveBook_Types_Book old =
    { id = old.id
    , dirty = old.dirty
    , slug = old.slug
    , origin = old.origin
    , author = old.author
    , createdAt = old.createdAt
    , updatedAt = old.updatedAt
    , public = old.public
    , title = old.title
    , cells = old.cells |> List.map migrate_LiveBook_Types_Cell
    , currentIndex = old.currentIndex
    }


migrate_LiveBook_Types_Cell : Evergreen.V20.LiveBook.Types.Cell -> Evergreen.V30.LiveBook.Types.Cell
migrate_LiveBook_Types_Cell old =
    { index = old.index
    , text = old.text
    , value = old.value |> migrate_LiveBook_Types_CellValue
    , cellState = old.cellState |> migrate_LiveBook_Types_CellState
    , locked = old.locked
    }


migrate_LiveBook_Types_CellState : Evergreen.V20.LiveBook.Types.CellState -> Evergreen.V30.LiveBook.Types.CellState
migrate_LiveBook_Types_CellState old =
    case old of
        Evergreen.V20.LiveBook.Types.CSEdit ->
            Evergreen.V30.LiveBook.Types.CSEdit

        Evergreen.V20.LiveBook.Types.CSView ->
            Evergreen.V30.LiveBook.Types.CSView


migrate_LiveBook_Types_CellValue : Evergreen.V20.LiveBook.Types.CellValue -> Evergreen.V30.LiveBook.Types.CellValue
migrate_LiveBook_Types_CellValue old =
    case old of
        Evergreen.V20.LiveBook.Types.CVNone ->
            Evergreen.V30.LiveBook.Types.CVNone

        Evergreen.V20.LiveBook.Types.CVString p0 ->
            Evergreen.V30.LiveBook.Types.CVString p0

        Evergreen.V20.LiveBook.Types.CVVisual p0 p1 ->
            Evergreen.V30.LiveBook.Types.CVVisual (p0 |> migrate_LiveBook_Types_VisualType) p1


migrate_LiveBook_Types_VisualType : Evergreen.V20.LiveBook.Types.VisualType -> Evergreen.V30.LiveBook.Types.VisualType
migrate_LiveBook_Types_VisualType old =
    case old of
        Evergreen.V20.LiveBook.Types.VTChart ->
            Evergreen.V30.LiveBook.Types.VTChart

        Evergreen.V20.LiveBook.Types.VTImage ->
            Evergreen.V30.LiveBook.Types.VTImage


migrate_Types_AppMode : Evergreen.V20.Types.AppMode -> Evergreen.V30.Types.AppMode
migrate_Types_AppMode old =
    case old of
        Evergreen.V20.Types.AMWorking ->
            Evergreen.V30.Types.AMWorking

        Evergreen.V20.Types.AMEditTitle ->
            Evergreen.V30.Types.AMEditTitle


migrate_Types_AppState : Evergreen.V20.Types.AppState -> Evergreen.V30.Types.AppState
migrate_Types_AppState old =
    case old of
        Evergreen.V20.Types.Loading ->
            Evergreen.V30.Types.Loading

        Evergreen.V20.Types.Loaded ->
            Evergreen.V30.Types.Loaded


migrate_Types_DeleteNotebookState : Evergreen.V20.Types.DeleteNotebookState -> Evergreen.V30.Types.DeleteNotebookState
migrate_Types_DeleteNotebookState old =
    case old of
        Evergreen.V20.Types.WaitingToDeleteNotebook ->
            Evergreen.V30.Types.WaitingToDeleteNotebook

        Evergreen.V20.Types.CanDeleteNotebook ->
            Evergreen.V30.Types.CanDeleteNotebook


migrate_Types_FrontendMsg : Evergreen.V20.Types.FrontendMsg -> Evergreen.V30.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V20.Types.UrlClicked p0 ->
            Evergreen.V30.Types.UrlClicked p0

        Evergreen.V20.Types.UrlChanged p0 ->
            Evergreen.V30.Types.UrlChanged p0

        Evergreen.V20.Types.NoOpFrontendMsg ->
            Evergreen.V30.Types.NoOpFrontendMsg

        Evergreen.V20.Types.FETick p0 ->
            Evergreen.V30.Types.FETick p0

        Evergreen.V20.Types.KeyboardMsg p0 ->
            Evergreen.V30.Types.KeyboardMsg p0

        Evergreen.V20.Types.StringDataRequested p0 p1 ->
            Evergreen.V30.Types.StringDataRequested p0 p1

        Evergreen.V20.Types.StringDataSelected p0 p1 p2 ->
            Evergreen.V30.Types.StringDataSelected p0 p1 p2

        Evergreen.V20.Types.StringDataLoaded p0 p1 p2 p3 ->
            Evergreen.V30.Types.StringDataLoaded p0 p1 p2 p3

        Evergreen.V20.Types.InputName p0 ->
            Evergreen.V30.Types.InputName p0

        Evergreen.V20.Types.InputDescription p0 ->
            Evergreen.V30.Types.InputDescription p0

        Evergreen.V20.Types.InputComments p0 ->
            Evergreen.V30.Types.InputComments p0

        Evergreen.V20.Types.InputData p0 ->
            Evergreen.V30.Types.InputData p0

        Evergreen.V20.Types.InputAuthor p0 ->
            Evergreen.V30.Types.InputAuthor p0

        Evergreen.V20.Types.AskToCreateDataSet ->
            Evergreen.V30.Types.AskToCreateDataSet

        Evergreen.V20.Types.ToggleCellLock p0 ->
            Evergreen.V30.Types.ToggleCellLock (p0 |> migrate_LiveBook_Types_Cell)

        Evergreen.V20.Types.NewCell p0 ->
            Evergreen.V30.Types.NewCell p0

        Evergreen.V20.Types.DeleteCell p0 ->
            Evergreen.V30.Types.DeleteCell p0

        Evergreen.V20.Types.EditCell p0 ->
            Evergreen.V30.Types.EditCell p0

        Evergreen.V20.Types.ClearCell p0 ->
            Evergreen.V30.Types.ClearCell p0

        Evergreen.V20.Types.EvalCell p0 ->
            Evergreen.V30.Types.EvalCell p0

        Evergreen.V20.Types.InputElmCode p0 p1 ->
            Evergreen.V30.Types.InputElmCode p0 p1

        Evergreen.V20.Types.UpdateNotebookTitle ->
            Evergreen.V30.Types.UpdateNotebookTitle

        Evergreen.V20.Types.NewNotebook ->
            Evergreen.V30.Types.NewNotebook

        Evergreen.V20.Types.ProposeDeletingNotebook ->
            Evergreen.V30.Types.ProposeDeletingNotebook

        Evergreen.V20.Types.CancelDeleteNotebook ->
            Evergreen.V30.Types.CancelDeleteNotebook

        Evergreen.V20.Types.ChangeAppMode p0 ->
            Evergreen.V30.Types.ChangeAppMode (p0 |> migrate_Types_AppMode)

        Evergreen.V20.Types.TogglePublic ->
            Evergreen.V30.Types.TogglePublic

        Evergreen.V20.Types.ClearNotebookValues ->
            Evergreen.V30.Types.ClearNotebookValues

        Evergreen.V20.Types.SetCurrentNotebook p0 ->
            Evergreen.V30.Types.SetCurrentNotebook (p0 |> migrate_LiveBook_Types_Book)

        Evergreen.V20.Types.CloneNotebook ->
            Evergreen.V30.Types.CloneNotebook

        Evergreen.V20.Types.PullNotebook ->
            Evergreen.V30.Types.PullNotebook

        Evergreen.V20.Types.SetShowNotebooksState p0 ->
            Evergreen.V30.Types.SetShowNotebooksState (p0 |> migrate_Types_ShowNotebooks)

        Evergreen.V20.Types.ChangePopup p0 ->
            Evergreen.V30.Types.ChangePopup (p0 |> migrate_Types_PopupState)

        Evergreen.V20.Types.GotViewport p0 ->
            Evergreen.V30.Types.GotViewport p0

        Evergreen.V20.Types.GotNewWindowDimensions p0 p1 ->
            Evergreen.V30.Types.GotNewWindowDimensions p0 p1

        Evergreen.V20.Types.SignUp ->
            Evergreen.V30.Types.SignUp

        Evergreen.V20.Types.SignIn ->
            Evergreen.V30.Types.SignIn

        Evergreen.V20.Types.SignOut ->
            Evergreen.V30.Types.SignOut

        Evergreen.V20.Types.SetSignupState p0 ->
            Evergreen.V30.Types.SetSignupState (p0 |> migrate_Types_SignupState)

        Evergreen.V20.Types.InputUsername p0 ->
            Evergreen.V30.Types.InputUsername p0

        Evergreen.V20.Types.InputSignupUsername p0 ->
            Evergreen.V30.Types.InputSignupUsername p0

        Evergreen.V20.Types.InputPassword p0 ->
            Evergreen.V30.Types.InputPassword p0

        Evergreen.V20.Types.InputPasswordAgain p0 ->
            Evergreen.V30.Types.InputPasswordAgain p0

        Evergreen.V20.Types.InputEmail p0 ->
            Evergreen.V30.Types.InputEmail p0

        Evergreen.V20.Types.InputTitle p0 ->
            Evergreen.V30.Types.InputTitle p0

        Evergreen.V20.Types.InputCloneReference p0 ->
            Evergreen.V30.Types.InputCloneReference p0

        Evergreen.V20.Types.AdminRunTask ->
            Evergreen.V30.Types.AdminRunTask

        Evergreen.V20.Types.GetUsers ->
            Evergreen.V30.Types.GetUsers


migrate_Types_Message : Evergreen.V20.Types.Message -> Evergreen.V30.Types.Message
migrate_Types_Message old =
    { txt = old.txt
    , status = old.status |> migrate_Types_MessageStatus
    }


migrate_Types_MessageStatus : Evergreen.V20.Types.MessageStatus -> Evergreen.V30.Types.MessageStatus
migrate_Types_MessageStatus old =
    case old of
        Evergreen.V20.Types.MSWhite ->
            Evergreen.V30.Types.MSWhite

        Evergreen.V20.Types.MSYellow ->
            Evergreen.V30.Types.MSYellow

        Evergreen.V20.Types.MSGreen ->
            Evergreen.V30.Types.MSGreen

        Evergreen.V20.Types.MSRed ->
            Evergreen.V30.Types.MSRed


migrate_Types_PopupState : Evergreen.V20.Types.PopupState -> Evergreen.V30.Types.PopupState
migrate_Types_PopupState old =
    case old of
        Evergreen.V20.Types.NoPopup ->
            Evergreen.V30.Types.NoPopup

        Evergreen.V20.Types.AdminPopup ->
            Evergreen.V30.Types.AdminPopup

        Evergreen.V20.Types.ManualPopup ->
            Evergreen.V30.Types.ManualPopup

        Evergreen.V20.Types.DataSetPopup ->
            Evergreen.V30.Types.DataSetPopup

        Evergreen.V20.Types.SignUpPopup ->
            Evergreen.V30.Types.SignUpPopup

        Evergreen.V20.Types.NewNotebookPopup ->
            Evergreen.V30.Types.NewNotebookPopup


migrate_Types_ShowNotebooks : Evergreen.V20.Types.ShowNotebooks -> Evergreen.V30.Types.ShowNotebooks
migrate_Types_ShowNotebooks old =
    case old of
        Evergreen.V20.Types.ShowUserNotebooks ->
            Evergreen.V30.Types.ShowUserNotebooks

        Evergreen.V20.Types.ShowPublicNotebooks ->
            Evergreen.V30.Types.ShowPublicNotebooks


migrate_Types_SignupState : Evergreen.V20.Types.SignupState -> Evergreen.V30.Types.SignupState
migrate_Types_SignupState old =
    case old of
        Evergreen.V20.Types.ShowSignUpForm ->
            Evergreen.V30.Types.ShowSignUpForm

        Evergreen.V20.Types.HideSignUpForm ->
            Evergreen.V30.Types.HideSignUpForm


migrate_Types_ToBackend : Evergreen.V20.Types.ToBackend -> Evergreen.V30.Types.ToBackend
migrate_Types_ToBackend old =
    case old of
        Evergreen.V20.Types.NoOpToBackend ->
            Evergreen.V30.Types.NoOpToBackend

        Evergreen.V20.Types.RunTask ->
            Evergreen.V30.Types.RunTask

        Evergreen.V20.Types.SendUsers ->
            Evergreen.V30.Types.SendUsers

        Evergreen.V20.Types.CreateDataSet p0 ->
            Evergreen.V30.Types.CreateDataSet (p0 |> migrate_LiveBook_DataSet_DataSet)

        Evergreen.V20.Types.GetData p0 p1 p2 ->
            Evergreen.V30.Types.GetData p0 p1 p2

        Evergreen.V20.Types.GetDataSetForDownload p0 ->
            Evergreen.V30.Types.GetDataSetForDownload p0

        Evergreen.V20.Types.CreateNotebook p0 p1 ->
            Evergreen.V30.Types.CreateNotebook p0 p1

        Evergreen.V20.Types.SaveNotebook p0 ->
            Evergreen.V30.Types.SaveNotebook (p0 |> migrate_LiveBook_Types_Book)

        Evergreen.V20.Types.DeleteNotebook p0 ->
            Evergreen.V30.Types.DeleteNotebook (p0 |> migrate_LiveBook_Types_Book)

        Evergreen.V20.Types.GetClonedNotebook p0 p1 ->
            Evergreen.V30.Types.GetClonedNotebook p0 p1

        Evergreen.V20.Types.GetPulledNotebook p0 p1 p2 p3 ->
            Evergreen.V30.Types.GetPulledNotebook p0 p1 p2 p3

        Evergreen.V20.Types.UpdateSlugDict p0 ->
            Evergreen.V30.Types.UpdateSlugDict (p0 |> migrate_LiveBook_Types_Book)

        Evergreen.V20.Types.GetUsersNotebooks p0 ->
            Evergreen.V30.Types.GetUsersNotebooks p0

        Evergreen.V20.Types.GetPublicNotebooks p0 ->
            Evergreen.V30.Types.GetPublicNotebooks p0

        Evergreen.V20.Types.SignUpBE p0 p1 p2 ->
            Evergreen.V30.Types.SignUpBE p0 p1 p2

        Evergreen.V20.Types.SignInBEDev ->
            Evergreen.V30.Types.SignInBEDev

        Evergreen.V20.Types.SignInBE p0 p1 ->
            Evergreen.V30.Types.SignInBE p0 p1

        Evergreen.V20.Types.SignOutBE p0 ->
            Evergreen.V30.Types.SignOutBE p0

        Evergreen.V20.Types.UpdateUserWith p0 ->
            Evergreen.V30.Types.UpdateUserWith (p0 |> migrate_User_User)


migrate_Types_ToFrontend : Evergreen.V20.Types.ToFrontend -> Evergreen.V30.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V20.Types.NoOpToFrontend ->
            Evergreen.V30.Types.NoOpToFrontend

        Evergreen.V20.Types.MessageReceived p0 ->
            Evergreen.V30.Types.MessageReceived (p0 |> migrate_Types_Message)

        Evergreen.V20.Types.GotUsers p0 ->
            Evergreen.V30.Types.GotUsers p0

        Evergreen.V20.Types.GotData p0 p1 p2 ->
            Evergreen.V30.Types.GotData p0 p1 (p2 |> migrate_LiveBook_DataSet_DataSet)

        Evergreen.V20.Types.GotDataForDownload p0 ->
            Evergreen.V30.Types.GotDataForDownload (p0 |> migrate_LiveBook_DataSet_DataSet)

        Evergreen.V20.Types.GotNotebook p0 ->
            Evergreen.V30.Types.GotNotebook (p0 |> migrate_LiveBook_Types_Book)

        Evergreen.V20.Types.GotNotebooks p0 ->
            Evergreen.V30.Types.GotNotebooks (p0 |> List.map migrate_LiveBook_Types_Book)

        Evergreen.V20.Types.SendMessage p0 ->
            Evergreen.V30.Types.SendMessage p0

        Evergreen.V20.Types.UserSignedIn p0 p1 ->
            Evergreen.V30.Types.UserSignedIn (p0 |> migrate_User_User) p1

        Evergreen.V20.Types.SendUser p0 ->
            Evergreen.V30.Types.SendUser (p0 |> migrate_User_User)


migrate_User_User : Evergreen.V20.User.User -> Evergreen.V30.User.User
migrate_User_User old =
    old