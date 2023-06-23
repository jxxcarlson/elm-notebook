module Evergreen.Migrate.V18 exposing (..)

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
import Evergreen.V17.Authentication
import Evergreen.V17.Credentials
import Evergreen.V17.Types
import Evergreen.V17.User
import Evergreen.V18.Authentication
import Evergreen.V18.Credentials
import Evergreen.V18.Types
import Evergreen.V18.User
import Lamdera.Migrations exposing (..)
import List
import Maybe


frontendModel : Evergreen.V17.Types.FrontendModel -> ModelMigration Evergreen.V18.Types.FrontendModel Evergreen.V18.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V17.Types.BackendModel -> ModelMigration Evergreen.V18.Types.BackendModel Evergreen.V18.Types.BackendMsg
backendModel old =
    ModelMigrated ( migrate_Types_BackendModel old, Cmd.none )


frontendMsg : Evergreen.V17.Types.FrontendMsg -> MsgMigration Evergreen.V18.Types.FrontendMsg Evergreen.V18.Types.FrontendMsg
frontendMsg old =
    MsgUnchanged


toBackend : Evergreen.V17.Types.ToBackend -> MsgMigration Evergreen.V18.Types.ToBackend Evergreen.V18.Types.BackendMsg
toBackend old =
    MsgMigrated ( migrate_Types_ToBackend old, Cmd.none )


backendMsg : Evergreen.V17.Types.BackendMsg -> MsgMigration Evergreen.V18.Types.BackendMsg Evergreen.V18.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V17.Types.ToFrontend -> MsgMigration Evergreen.V18.Types.ToFrontend Evergreen.V18.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_BackendModel : Evergreen.V17.Types.BackendModel -> Evergreen.V18.Types.BackendModel
migrate_Types_BackendModel old =
    { message = old.message
    , currentTime = old.currentTime
    , randomSeed = old.randomSeed
    , uuidCount = old.uuidCount
    , uuid = old.uuid
    , randomAtmosphericInt = old.randomAtmosphericInt
    , authenticationDict = old.authenticationDict |> migrate_Authentication_AuthenticationDict
    , userToNoteBookDict = old.userToNoteBookDict |> migrate_Types_UserToNoteBookDict
    }


migrate_Types_FrontendModel : Evergreen.V17.Types.FrontendModel -> Evergreen.V18.Types.FrontendModel
migrate_Types_FrontendModel old =
    { key = old.key
    , url = old.url
    , message = old.message
    , messages = old.messages |> List.map migrate_Types_Message
    , appState = old.appState |> migrate_Types_AppState
    , appMode = old.appMode |> migrate_Types_AppMode
    , currentTime = old.currentTime
    , users = old.users |> List.map migrate_User_User
    , books = old.books |> List.map migrate_Types_Book
    , currentBook = old.currentBook |> migrate_Types_Book
    , cellContent = old.cellContent
    , signupState = old.signupState |> migrate_Types_SignupState
    , currentUser = old.currentUser |> Maybe.map migrate_User_User
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


migrate_Authentication_AuthenticationDict : Evergreen.V17.Authentication.AuthenticationDict -> Evergreen.V18.Authentication.AuthenticationDict
migrate_Authentication_AuthenticationDict old =
    old |> Dict.map (\k -> migrate_Authentication_UserData)


migrate_Authentication_UserData : Evergreen.V17.Authentication.UserData -> Evergreen.V18.Authentication.UserData
migrate_Authentication_UserData old =
    { user = old.user |> migrate_User_User
    , credentials = old.credentials |> migrate_Credentials_Credentials
    }


migrate_Credentials_Credentials : Evergreen.V17.Credentials.Credentials -> Evergreen.V18.Credentials.Credentials
migrate_Credentials_Credentials old =
    case old of
        Evergreen.V17.Credentials.V1 p0 p1 ->
            Evergreen.V18.Credentials.V1 p0 p1


migrate_Types_AppMode : Evergreen.V17.Types.AppMode -> Evergreen.V18.Types.AppMode
migrate_Types_AppMode old =
    case old of
        Evergreen.V17.Types.AMWorking ->
            Evergreen.V18.Types.AMWorking

        Evergreen.V17.Types.AMEditTitle ->
            Evergreen.V18.Types.AMEditTitle


migrate_Types_AppState : Evergreen.V17.Types.AppState -> Evergreen.V18.Types.AppState
migrate_Types_AppState old =
    case old of
        Evergreen.V17.Types.Loading ->
            Evergreen.V18.Types.Loading

        Evergreen.V17.Types.Loaded ->
            Evergreen.V18.Types.Loaded


migrate_Types_Book : Evergreen.V17.Types.Book -> Evergreen.V18.Types.Book
migrate_Types_Book old =
    { id = old.id
    , dirty = old.dirty
    , slug = old.slug
    , author = old.author
    , createdAt = old.createdAt
    , updatedAt = old.updatedAt
    , public = old.public
    , title = old.title
    , cells = old.cells |> List.map migrate_Types_Cell
    , currentIndex = old.currentIndex
    }


migrate_Types_Cell : Evergreen.V17.Types.Cell -> Evergreen.V18.Types.Cell
migrate_Types_Cell old =
    { index = old.index
    , text = old.text
    , value = old.value
    , cellState = old.cellState |> migrate_Types_CellState
    }


migrate_Types_CellState : Evergreen.V17.Types.CellState -> Evergreen.V18.Types.CellState
migrate_Types_CellState old =
    case old of
        Evergreen.V17.Types.CSEdit ->
            Evergreen.V18.Types.CSEdit

        Evergreen.V17.Types.CSView ->
            Evergreen.V18.Types.CSView


migrate_Types_Message : Evergreen.V17.Types.Message -> Evergreen.V18.Types.Message
migrate_Types_Message old =
    { txt = old.txt
    , status = old.status |> migrate_Types_MessageStatus
    }


migrate_Types_MessageStatus : Evergreen.V17.Types.MessageStatus -> Evergreen.V18.Types.MessageStatus
migrate_Types_MessageStatus old =
    case old of
        Evergreen.V17.Types.MSWhite ->
            Evergreen.V18.Types.MSWhite

        Evergreen.V17.Types.MSYellow ->
            Evergreen.V18.Types.MSYellow

        Evergreen.V17.Types.MSGreen ->
            Evergreen.V18.Types.MSGreen

        Evergreen.V17.Types.MSRed ->
            Evergreen.V18.Types.MSRed


migrate_Types_NoteBookDict : Evergreen.V17.Types.NoteBookDict -> Evergreen.V18.Types.NoteBookDict
migrate_Types_NoteBookDict old =
    old |> Dict.map (\k -> migrate_Types_Book)


migrate_Types_PopupState : Evergreen.V17.Types.PopupState -> Evergreen.V18.Types.PopupState
migrate_Types_PopupState old =
    case old of
        Evergreen.V17.Types.NoPopup ->
            Evergreen.V18.Types.NoPopup

        Evergreen.V17.Types.AdminPopup ->
            Evergreen.V18.Types.AdminPopup

        Evergreen.V17.Types.SignUpPopup ->
            Evergreen.V18.Types.SignUpPopup

        Evergreen.V17.Types.NewNotebookPopup ->
            Evergreen.V18.Types.NewNotebookPopup


migrate_Types_SignupState : Evergreen.V17.Types.SignupState -> Evergreen.V18.Types.SignupState
migrate_Types_SignupState old =
    case old of
        Evergreen.V17.Types.ShowSignUpForm ->
            Evergreen.V18.Types.ShowSignUpForm

        Evergreen.V17.Types.HideSignUpForm ->
            Evergreen.V18.Types.HideSignUpForm


migrate_Types_ToBackend : Evergreen.V17.Types.ToBackend -> Evergreen.V18.Types.ToBackend
migrate_Types_ToBackend old =
    case old of
        Evergreen.V17.Types.NoOpToBackend ->
            Evergreen.V18.Types.NoOpToBackend

        Evergreen.V17.Types.RunTask ->
            Evergreen.V18.Types.RunTask

        Evergreen.V17.Types.SendUsers ->
            Evergreen.V18.Types.SendUsers

        Evergreen.V17.Types.CreateNotebook p0 p1 ->
            Evergreen.V18.Types.CreateNotebook p0 p1

        Evergreen.V17.Types.SaveNotebook p0 ->
            Evergreen.V18.Types.SaveNotebook (p0 |> migrate_Types_Book)

        Evergreen.V17.Types.SignUpBE p0 p1 p2 ->
            Evergreen.V18.Types.SignUpBE p0 p1 p2

        Evergreen.V17.Types.SignInBEDev ->
            Evergreen.V18.Types.SignInBEDev

        Evergreen.V17.Types.SignInBE p0 p1 ->
            Evergreen.V18.Types.SignInBE p0 p1

        Evergreen.V17.Types.SignOutBE p0 ->
            Evergreen.V18.Types.SignOutBE p0

        Evergreen.V17.Types.UpdateUserWith p0 ->
            Evergreen.V18.Types.UpdateUserWith (p0 |> migrate_User_User)


migrate_Types_ToFrontend : Evergreen.V17.Types.ToFrontend -> Evergreen.V18.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V17.Types.NoOpToFrontend ->
            Evergreen.V18.Types.NoOpToFrontend

        Evergreen.V17.Types.MessageReceived p0 ->
            Evergreen.V18.Types.MessageReceived (p0 |> migrate_Types_Message)

        Evergreen.V17.Types.GotUsers p0 ->
            Evergreen.V18.Types.GotUsers (p0 |> List.map migrate_User_User)

        Evergreen.V17.Types.GotNotebook p0 ->
            Evergreen.V18.Types.GotNotebook (p0 |> migrate_Types_Book)

        Evergreen.V17.Types.GotNotebooks p0 ->
            Evergreen.V18.Types.GotNotebooks (p0 |> List.map migrate_Types_Book)

        Evergreen.V17.Types.SendMessage p0 ->
            Evergreen.V18.Types.SendMessage p0

        Evergreen.V17.Types.UserSignedIn p0 p1 ->
            Evergreen.V18.Types.UserSignedIn (p0 |> migrate_User_User) p1

        Evergreen.V17.Types.SendUser p0 ->
            Evergreen.V18.Types.SendUser (p0 |> migrate_User_User)


migrate_Types_UserToNoteBookDict : Evergreen.V17.Types.UserToNoteBookDict -> Evergreen.V18.Types.UserToNoteBookDict
migrate_Types_UserToNoteBookDict old =
    old |> Dict.map (\k -> migrate_Types_NoteBookDict)


migrate_User_User : Evergreen.V17.User.User -> Evergreen.V18.User.User
migrate_User_User old =
    { username = old.username
    , id = old.id
    , realname = old.realname
    , email = old.email
    , created = old.created
    , modified = old.modified
    , locked = old.locked
    , currentNotebookId = Nothing
    }