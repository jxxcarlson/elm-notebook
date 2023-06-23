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

import Dict
import Evergreen.V27.Authentication
import Evergreen.V27.Credentials
import Evergreen.V27.Types
import Evergreen.V27.User
import Evergreen.V30.Authentication
import Evergreen.V30.Credentials
import Evergreen.V30.Types
import Evergreen.V30.User
import Lamdera.Migrations exposing (..)
import List


frontendModel : Evergreen.V27.Types.FrontendModel -> ModelMigration Evergreen.V30.Types.FrontendModel Evergreen.V30.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V27.Types.BackendModel -> ModelMigration Evergreen.V30.Types.BackendModel Evergreen.V30.Types.BackendMsg
backendModel old =
    ModelMigrated ( migrate_Types_BackendModel old, Cmd.none )


frontendMsg : Evergreen.V27.Types.FrontendMsg -> MsgMigration Evergreen.V30.Types.FrontendMsg Evergreen.V30.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V27.Types.ToBackend -> MsgMigration Evergreen.V30.Types.ToBackend Evergreen.V30.Types.BackendMsg
toBackend old =
    MsgMigrated ( migrate_Types_ToBackend old, Cmd.none )


backendMsg : Evergreen.V27.Types.BackendMsg -> MsgMigration Evergreen.V30.Types.BackendMsg Evergreen.V30.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V27.Types.ToFrontend -> MsgMigration Evergreen.V30.Types.ToFrontend Evergreen.V30.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_BackendModel : Evergreen.V27.Types.BackendModel -> Evergreen.V30.Types.BackendModel
migrate_Types_BackendModel old =
    { message = old.message
    , currentTime = old.currentTime
    , randomSeed = old.randomSeed
    , uuidCount = old.uuidCount
    , uuid = old.uuid
    , randomAtmosphericInt = old.randomAtmosphericInt
    , userToNoteBookDict = old.userToNoteBookDict |> migrate_Types_UserToNoteBookDict
    , slugDict = old.slugDict
    , authenticationDict = old.authenticationDict |> migrate_Authentication_AuthenticationDict
    }


migrate_Types_FrontendModel : Evergreen.V27.Types.FrontendModel -> Evergreen.V30.Types.FrontendModel
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


migrate_Authentication_AuthenticationDict : Evergreen.V27.Authentication.AuthenticationDict -> Evergreen.V30.Authentication.AuthenticationDict
migrate_Authentication_AuthenticationDict old =
    old |> Dict.map (\k -> migrate_Authentication_UserData)


migrate_Authentication_UserData : Evergreen.V27.Authentication.UserData -> Evergreen.V30.Authentication.UserData
migrate_Authentication_UserData old =
    { user = old.user |> migrate_User_User
    , credentials = old.credentials |> migrate_Credentials_Credentials
    }


migrate_Credentials_Credentials : Evergreen.V27.Credentials.Credentials -> Evergreen.V30.Credentials.Credentials
migrate_Credentials_Credentials old =
    case old of
        Evergreen.V27.Credentials.V1 p0 p1 ->
            Evergreen.V30.Credentials.V1 p0 p1


migrate_Types_AppMode : Evergreen.V27.Types.AppMode -> Evergreen.V30.Types.AppMode
migrate_Types_AppMode old =
    case old of
        Evergreen.V27.Types.AMWorking ->
            Evergreen.V30.Types.AMWorking

        Evergreen.V27.Types.AMEditTitle ->
            Evergreen.V30.Types.AMEditTitle


migrate_Types_AppState : Evergreen.V27.Types.AppState -> Evergreen.V30.Types.AppState
migrate_Types_AppState old =
    case old of
        Evergreen.V27.Types.Loading ->
            Evergreen.V30.Types.Loading

        Evergreen.V27.Types.Loaded ->
            Evergreen.V30.Types.Loaded


migrate_Types_Book : Evergreen.V27.Types.Book -> Evergreen.V30.Types.Book
migrate_Types_Book old =
    { id = old.id
    , dirty = old.dirty
    , slug = old.slug
    , origin = Nothing
    , author = old.author
    , createdAt = old.createdAt
    , updatedAt = old.updatedAt
    , public = old.public
    , title = old.title
    , cells = old.cells |> List.map migrate_Types_Cell
    , currentIndex = old.currentIndex
    }


migrate_Types_Cell : Evergreen.V27.Types.Cell -> Evergreen.V30.Types.Cell
migrate_Types_Cell old =
    { index = old.index
    , text = old.text
    , value = old.value
    , cellState = old.cellState |> migrate_Types_CellState
    }


migrate_Types_CellState : Evergreen.V27.Types.CellState -> Evergreen.V30.Types.CellState
migrate_Types_CellState old =
    case old of
        Evergreen.V27.Types.CSEdit ->
            Evergreen.V30.Types.CSEdit

        Evergreen.V27.Types.CSView ->
            Evergreen.V30.Types.CSView


migrate_Types_FrontendMsg : Evergreen.V27.Types.FrontendMsg -> Evergreen.V30.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V27.Types.UrlClicked p0 ->
            Evergreen.V30.Types.UrlClicked p0

        Evergreen.V27.Types.UrlChanged p0 ->
            Evergreen.V30.Types.UrlChanged p0

        Evergreen.V27.Types.NoOpFrontendMsg ->
            Evergreen.V30.Types.NoOpFrontendMsg

        Evergreen.V27.Types.FETick p0 ->
            Evergreen.V30.Types.FETick p0

        Evergreen.V27.Types.KeyboardMsg p0 ->
            Evergreen.V30.Types.KeyboardMsg p0

        Evergreen.V27.Types.NewCell p0 ->
            Evergreen.V30.Types.NewCell p0

        Evergreen.V27.Types.EditCell p0 ->
            Evergreen.V30.Types.EditCell p0

        Evergreen.V27.Types.ClearCell p0 ->
            Evergreen.V30.Types.ClearCell p0

        Evergreen.V27.Types.EvalCell p0 ->
            Evergreen.V30.Types.EvalCell p0

        Evergreen.V27.Types.InputElmCode p0 p1 ->
            Evergreen.V30.Types.InputElmCode p0 p1

        Evergreen.V27.Types.UpdateNotebookTitle ->
            Evergreen.V30.Types.UpdateNotebookTitle

        Evergreen.V27.Types.NewNotebook ->
            Evergreen.V30.Types.NewNotebook

        Evergreen.V27.Types.ChangeAppMode p0 ->
            Evergreen.V30.Types.ChangeAppMode (p0 |> migrate_Types_AppMode)

        Evergreen.V27.Types.TogglePublic ->
            Evergreen.V30.Types.TogglePublic

        Evergreen.V27.Types.SetCurrentNotebook p0 ->
            Evergreen.V30.Types.SetCurrentNotebook (p0 |> migrate_Types_Book)

        Evergreen.V27.Types.CloneNotebook ->
            Evergreen.V30.Types.CloneNotebook

        Evergreen.V27.Types.ChangePopup p0 ->
            Evergreen.V30.Types.ChangePopup (p0 |> migrate_Types_PopupState)

        Evergreen.V27.Types.GotViewport p0 ->
            Evergreen.V30.Types.GotViewport p0

        Evergreen.V27.Types.GotNewWindowDimensions p0 p1 ->
            Evergreen.V30.Types.GotNewWindowDimensions p0 p1

        Evergreen.V27.Types.SignUp ->
            Evergreen.V30.Types.SignUp

        Evergreen.V27.Types.SignIn ->
            Evergreen.V30.Types.SignIn

        Evergreen.V27.Types.SignOut ->
            Evergreen.V30.Types.SignOut

        Evergreen.V27.Types.SetSignupState p0 ->
            Evergreen.V30.Types.SetSignupState (p0 |> migrate_Types_SignupState)

        Evergreen.V27.Types.InputUsername p0 ->
            Evergreen.V30.Types.InputUsername p0

        Evergreen.V27.Types.InputSignupUsername p0 ->
            Evergreen.V30.Types.InputSignupUsername p0

        Evergreen.V27.Types.InputPassword p0 ->
            Evergreen.V30.Types.InputPassword p0

        Evergreen.V27.Types.InputPasswordAgain p0 ->
            Evergreen.V30.Types.InputPasswordAgain p0

        Evergreen.V27.Types.InputEmail p0 ->
            Evergreen.V30.Types.InputEmail p0

        Evergreen.V27.Types.InputTitle p0 ->
            Evergreen.V30.Types.InputTitle p0

        Evergreen.V27.Types.InputCloneReference p0 ->
            Evergreen.V30.Types.InputCloneReference p0

        Evergreen.V27.Types.AdminRunTask ->
            Evergreen.V30.Types.AdminRunTask

        Evergreen.V27.Types.GetUsers ->
            Evergreen.V30.Types.GetUsers


migrate_Types_Message : Evergreen.V27.Types.Message -> Evergreen.V30.Types.Message
migrate_Types_Message old =
    { txt = old.txt
    , status = old.status |> migrate_Types_MessageStatus
    }


migrate_Types_MessageStatus : Evergreen.V27.Types.MessageStatus -> Evergreen.V30.Types.MessageStatus
migrate_Types_MessageStatus old =
    case old of
        Evergreen.V27.Types.MSWhite ->
            Evergreen.V30.Types.MSWhite

        Evergreen.V27.Types.MSYellow ->
            Evergreen.V30.Types.MSYellow

        Evergreen.V27.Types.MSGreen ->
            Evergreen.V30.Types.MSGreen

        Evergreen.V27.Types.MSRed ->
            Evergreen.V30.Types.MSRed


migrate_Types_NoteBookDict : Evergreen.V27.Types.NoteBookDict -> Evergreen.V30.Types.NoteBookDict
migrate_Types_NoteBookDict old =
    old |> Dict.map (\k -> migrate_Types_Book)


migrate_Types_PopupState : Evergreen.V27.Types.PopupState -> Evergreen.V30.Types.PopupState
migrate_Types_PopupState old =
    case old of
        Evergreen.V27.Types.NoPopup ->
            Evergreen.V30.Types.NoPopup

        Evergreen.V27.Types.AdminPopup ->
            Evergreen.V30.Types.AdminPopup

        Evergreen.V27.Types.ManualPopup ->
            Evergreen.V30.Types.ManualPopup

        Evergreen.V27.Types.SignUpPopup ->
            Evergreen.V30.Types.SignUpPopup

        Evergreen.V27.Types.NewNotebookPopup ->
            Evergreen.V30.Types.NewNotebookPopup


migrate_Types_SignupState : Evergreen.V27.Types.SignupState -> Evergreen.V30.Types.SignupState
migrate_Types_SignupState old =
    case old of
        Evergreen.V27.Types.ShowSignUpForm ->
            Evergreen.V30.Types.ShowSignUpForm

        Evergreen.V27.Types.HideSignUpForm ->
            Evergreen.V30.Types.HideSignUpForm


migrate_Types_ToBackend : Evergreen.V27.Types.ToBackend -> Evergreen.V30.Types.ToBackend
migrate_Types_ToBackend old =
    case old of
        Evergreen.V27.Types.NoOpToBackend ->
            Evergreen.V30.Types.NoOpToBackend

        Evergreen.V27.Types.RunTask ->
            Evergreen.V30.Types.RunTask

        Evergreen.V27.Types.SendUsers ->
            Evergreen.V30.Types.SendUsers

        Evergreen.V27.Types.CreateNotebook p0 p1 ->
            Evergreen.V30.Types.CreateNotebook p0 p1

        Evergreen.V27.Types.SaveNotebook p0 ->
            Evergreen.V30.Types.SaveNotebook (p0 |> migrate_Types_Book)

        Evergreen.V27.Types.GetClonedNotebook p0 p1 ->
            Evergreen.V30.Types.GetClonedNotebook p0 p1

        Evergreen.V27.Types.UpdateSlugDict p0 ->
            Evergreen.V30.Types.UpdateSlugDict (p0 |> migrate_Types_Book)

        Evergreen.V27.Types.SignUpBE p0 p1 p2 ->
            Evergreen.V30.Types.SignUpBE p0 p1 p2

        Evergreen.V27.Types.SignInBEDev ->
            Evergreen.V30.Types.SignInBEDev

        Evergreen.V27.Types.SignInBE p0 p1 ->
            Evergreen.V30.Types.SignInBE p0 p1

        Evergreen.V27.Types.SignOutBE p0 ->
            Evergreen.V30.Types.SignOutBE p0

        Evergreen.V27.Types.UpdateUserWith p0 ->
            Evergreen.V30.Types.UpdateUserWith (p0 |> migrate_User_User)


migrate_Types_ToFrontend : Evergreen.V27.Types.ToFrontend -> Evergreen.V30.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V27.Types.NoOpToFrontend ->
            Evergreen.V30.Types.NoOpToFrontend

        Evergreen.V27.Types.MessageReceived p0 ->
            Evergreen.V30.Types.MessageReceived (p0 |> migrate_Types_Message)

        Evergreen.V27.Types.GotUsers p0 ->
            Evergreen.V30.Types.GotUsers p0

        Evergreen.V27.Types.GotNotebook p0 ->
            Evergreen.V30.Types.GotNotebook (p0 |> migrate_Types_Book)

        Evergreen.V27.Types.GotNotebooks p0 ->
            Evergreen.V30.Types.GotNotebooks (p0 |> List.map migrate_Types_Book)

        Evergreen.V27.Types.SendMessage p0 ->
            Evergreen.V30.Types.SendMessage p0

        Evergreen.V27.Types.UserSignedIn p0 p1 ->
            Evergreen.V30.Types.UserSignedIn (p0 |> migrate_User_User) p1

        Evergreen.V27.Types.SendUser p0 ->
            Evergreen.V30.Types.SendUser (p0 |> migrate_User_User)


migrate_Types_UserToNoteBookDict : Evergreen.V27.Types.UserToNoteBookDict -> Evergreen.V30.Types.UserToNoteBookDict
migrate_Types_UserToNoteBookDict old =
    old |> Dict.map (\k -> migrate_Types_NoteBookDict)


migrate_User_User : Evergreen.V27.User.User -> Evergreen.V30.User.User
migrate_User_User old =
    old
