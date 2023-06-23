module Evergreen.Migrate.V35 exposing (..)

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

import Evergreen.V32.Types
import Evergreen.V32.User
import Evergreen.V35.Types
import Evergreen.V35.User
import Lamdera.Migrations exposing (..)
import List


frontendModel : Evergreen.V32.Types.FrontendModel -> ModelMigration Evergreen.V35.Types.FrontendModel Evergreen.V35.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V32.Types.BackendModel -> ModelMigration Evergreen.V35.Types.BackendModel Evergreen.V35.Types.BackendMsg
backendModel old =
    ModelUnchanged


frontendMsg : Evergreen.V32.Types.FrontendMsg -> MsgMigration Evergreen.V35.Types.FrontendMsg Evergreen.V35.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V32.Types.ToBackend -> MsgMigration Evergreen.V35.Types.ToBackend Evergreen.V35.Types.BackendMsg
toBackend old =
    MsgMigrated ( migrate_Types_ToBackend old, Cmd.none )


backendMsg : Evergreen.V32.Types.BackendMsg -> MsgMigration Evergreen.V35.Types.BackendMsg Evergreen.V35.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V32.Types.ToFrontend -> MsgMigration Evergreen.V35.Types.ToFrontend Evergreen.V35.Types.FrontendMsg
toFrontend old =
    MsgUnchanged


migrate_Types_FrontendModel : Evergreen.V32.Types.FrontendModel -> Evergreen.V35.Types.FrontendModel
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
    , books = old.books |> List.map migrate_Types_Book
    , currentBook = old.currentBook |> migrate_Types_Book
    , cellContent = old.cellContent
    , currentCellIndex = old.currentCellIndex
    , cloneReference = old.cloneReference
    , deleteNotebookState = Evergreen.V35.Types.WaitingToDeleteNotebook
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


migrate_Types_AppMode : Evergreen.V32.Types.AppMode -> Evergreen.V35.Types.AppMode
migrate_Types_AppMode old =
    case old of
        Evergreen.V32.Types.AMWorking ->
            Evergreen.V35.Types.AMWorking

        Evergreen.V32.Types.AMEditTitle ->
            Evergreen.V35.Types.AMEditTitle


migrate_Types_AppState : Evergreen.V32.Types.AppState -> Evergreen.V35.Types.AppState
migrate_Types_AppState old =
    case old of
        Evergreen.V32.Types.Loading ->
            Evergreen.V35.Types.Loading

        Evergreen.V32.Types.Loaded ->
            Evergreen.V35.Types.Loaded


migrate_Types_Book : Evergreen.V32.Types.Book -> Evergreen.V35.Types.Book
migrate_Types_Book old =
    { id = old.id
    , dirty = old.dirty
    , slug = old.slug
    , origin = old.origin
    , author = old.author
    , createdAt = old.createdAt
    , updatedAt = old.updatedAt
    , public = old.public
    , title = old.title
    , cells = old.cells |> List.map migrate_Types_Cell
    , currentIndex = old.currentIndex
    }


migrate_Types_Cell : Evergreen.V32.Types.Cell -> Evergreen.V35.Types.Cell
migrate_Types_Cell old =
    { index = old.index
    , text = old.text
    , value = old.value
    , cellState = old.cellState |> migrate_Types_CellState
    }


migrate_Types_CellState : Evergreen.V32.Types.CellState -> Evergreen.V35.Types.CellState
migrate_Types_CellState old =
    case old of
        Evergreen.V32.Types.CSEdit ->
            Evergreen.V35.Types.CSEdit

        Evergreen.V32.Types.CSView ->
            Evergreen.V35.Types.CSView


migrate_Types_FrontendMsg : Evergreen.V32.Types.FrontendMsg -> Evergreen.V35.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V32.Types.UrlClicked p0 ->
            Evergreen.V35.Types.UrlClicked p0

        Evergreen.V32.Types.UrlChanged p0 ->
            Evergreen.V35.Types.UrlChanged p0

        Evergreen.V32.Types.NoOpFrontendMsg ->
            Evergreen.V35.Types.NoOpFrontendMsg

        Evergreen.V32.Types.FETick p0 ->
            Evergreen.V35.Types.FETick p0

        Evergreen.V32.Types.KeyboardMsg p0 ->
            Evergreen.V35.Types.KeyboardMsg p0

        Evergreen.V32.Types.NewCell p0 ->
            Evergreen.V35.Types.NewCell p0

        Evergreen.V32.Types.EditCell p0 ->
            Evergreen.V35.Types.EditCell p0

        Evergreen.V32.Types.ClearCell p0 ->
            Evergreen.V35.Types.ClearCell p0

        Evergreen.V32.Types.EvalCell p0 ->
            Evergreen.V35.Types.EvalCell p0

        Evergreen.V32.Types.InputElmCode p0 p1 ->
            Evergreen.V35.Types.InputElmCode p0 p1

        Evergreen.V32.Types.UpdateNotebookTitle ->
            Evergreen.V35.Types.UpdateNotebookTitle

        Evergreen.V32.Types.NewNotebook ->
            Evergreen.V35.Types.NewNotebook

        Evergreen.V32.Types.ChangeAppMode p0 ->
            Evergreen.V35.Types.ChangeAppMode (p0 |> migrate_Types_AppMode)

        Evergreen.V32.Types.TogglePublic ->
            Evergreen.V35.Types.TogglePublic

        Evergreen.V32.Types.SetCurrentNotebook p0 ->
            Evergreen.V35.Types.SetCurrentNotebook (p0 |> migrate_Types_Book)

        Evergreen.V32.Types.CloneNotebook ->
            Evergreen.V35.Types.CloneNotebook

        Evergreen.V32.Types.PullNotebook ->
            Evergreen.V35.Types.PullNotebook

        Evergreen.V32.Types.ChangePopup p0 ->
            Evergreen.V35.Types.ChangePopup (p0 |> migrate_Types_PopupState)

        Evergreen.V32.Types.GotViewport p0 ->
            Evergreen.V35.Types.GotViewport p0

        Evergreen.V32.Types.GotNewWindowDimensions p0 p1 ->
            Evergreen.V35.Types.GotNewWindowDimensions p0 p1

        Evergreen.V32.Types.SignUp ->
            Evergreen.V35.Types.SignUp

        Evergreen.V32.Types.SignIn ->
            Evergreen.V35.Types.SignIn

        Evergreen.V32.Types.SignOut ->
            Evergreen.V35.Types.SignOut

        Evergreen.V32.Types.SetSignupState p0 ->
            Evergreen.V35.Types.SetSignupState (p0 |> migrate_Types_SignupState)

        Evergreen.V32.Types.InputUsername p0 ->
            Evergreen.V35.Types.InputUsername p0

        Evergreen.V32.Types.InputSignupUsername p0 ->
            Evergreen.V35.Types.InputSignupUsername p0

        Evergreen.V32.Types.InputPassword p0 ->
            Evergreen.V35.Types.InputPassword p0

        Evergreen.V32.Types.InputPasswordAgain p0 ->
            Evergreen.V35.Types.InputPasswordAgain p0

        Evergreen.V32.Types.InputEmail p0 ->
            Evergreen.V35.Types.InputEmail p0

        Evergreen.V32.Types.InputTitle p0 ->
            Evergreen.V35.Types.InputTitle p0

        Evergreen.V32.Types.InputCloneReference p0 ->
            Evergreen.V35.Types.InputCloneReference p0

        Evergreen.V32.Types.AdminRunTask ->
            Evergreen.V35.Types.AdminRunTask

        Evergreen.V32.Types.GetUsers ->
            Evergreen.V35.Types.GetUsers


migrate_Types_Message : Evergreen.V32.Types.Message -> Evergreen.V35.Types.Message
migrate_Types_Message old =
    { txt = old.txt
    , status = old.status |> migrate_Types_MessageStatus
    }


migrate_Types_MessageStatus : Evergreen.V32.Types.MessageStatus -> Evergreen.V35.Types.MessageStatus
migrate_Types_MessageStatus old =
    case old of
        Evergreen.V32.Types.MSWhite ->
            Evergreen.V35.Types.MSWhite

        Evergreen.V32.Types.MSYellow ->
            Evergreen.V35.Types.MSYellow

        Evergreen.V32.Types.MSGreen ->
            Evergreen.V35.Types.MSGreen

        Evergreen.V32.Types.MSRed ->
            Evergreen.V35.Types.MSRed


migrate_Types_PopupState : Evergreen.V32.Types.PopupState -> Evergreen.V35.Types.PopupState
migrate_Types_PopupState old =
    case old of
        Evergreen.V32.Types.NoPopup ->
            Evergreen.V35.Types.NoPopup

        Evergreen.V32.Types.AdminPopup ->
            Evergreen.V35.Types.AdminPopup

        Evergreen.V32.Types.ManualPopup ->
            Evergreen.V35.Types.ManualPopup

        Evergreen.V32.Types.SignUpPopup ->
            Evergreen.V35.Types.SignUpPopup

        Evergreen.V32.Types.NewNotebookPopup ->
            Evergreen.V35.Types.NewNotebookPopup


migrate_Types_SignupState : Evergreen.V32.Types.SignupState -> Evergreen.V35.Types.SignupState
migrate_Types_SignupState old =
    case old of
        Evergreen.V32.Types.ShowSignUpForm ->
            Evergreen.V35.Types.ShowSignUpForm

        Evergreen.V32.Types.HideSignUpForm ->
            Evergreen.V35.Types.HideSignUpForm


migrate_Types_ToBackend : Evergreen.V32.Types.ToBackend -> Evergreen.V35.Types.ToBackend
migrate_Types_ToBackend old =
    case old of
        Evergreen.V32.Types.NoOpToBackend ->
            Evergreen.V35.Types.NoOpToBackend

        Evergreen.V32.Types.RunTask ->
            Evergreen.V35.Types.RunTask

        Evergreen.V32.Types.SendUsers ->
            Evergreen.V35.Types.SendUsers

        Evergreen.V32.Types.CreateNotebook p0 p1 ->
            Evergreen.V35.Types.CreateNotebook p0 p1

        Evergreen.V32.Types.SaveNotebook p0 ->
            Evergreen.V35.Types.SaveNotebook (p0 |> migrate_Types_Book)

        Evergreen.V32.Types.GetClonedNotebook p0 p1 ->
            Evergreen.V35.Types.GetClonedNotebook p0 p1

        Evergreen.V32.Types.GetPulledNotebook p0 p1 ->
            Evergreen.V35.Types.GetPulledNotebook p0 p1

        Evergreen.V32.Types.UpdateSlugDict p0 ->
            Evergreen.V35.Types.UpdateSlugDict (p0 |> migrate_Types_Book)

        Evergreen.V32.Types.SignUpBE p0 p1 p2 ->
            Evergreen.V35.Types.SignUpBE p0 p1 p2

        Evergreen.V32.Types.SignInBEDev ->
            Evergreen.V35.Types.SignInBEDev

        Evergreen.V32.Types.SignInBE p0 p1 ->
            Evergreen.V35.Types.SignInBE p0 p1

        Evergreen.V32.Types.SignOutBE p0 ->
            Evergreen.V35.Types.SignOutBE p0

        Evergreen.V32.Types.UpdateUserWith p0 ->
            Evergreen.V35.Types.UpdateUserWith (p0 |> migrate_User_User)


migrate_User_User : Evergreen.V32.User.User -> Evergreen.V35.User.User
migrate_User_User old =
    old
