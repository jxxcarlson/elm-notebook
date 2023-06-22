module Types exposing (..)

import Authentication exposing (AuthenticationDict)
import Browser exposing (UrlRequest)
import Browser.Dom
import Browser.Navigation exposing (Key)
import Bytes
import Dict exposing (Dict)
import Keyboard
import Lamdera exposing (ClientId)
import Random
import Time
import Url exposing (Url)
import User exposing (User)


type alias FrontendModel =
    { key : Key
    , url : Url
    , message : String
    , messages : List Message
    , appState : AppState
    , appMode : AppMode
    , currentTime : Time.Posix
    , pressedKeys : List Keyboard.Key

    -- ADMIN
    , users : List User

    -- CELLS
    , books : List Book
    , currentBook : Book
    , cellContent : String
    , currentCellIndex : Int

    -- USER
    , signupState : SignupState
    , currentUser : Maybe User
    , inputUsername : String
    , inputSignupUsername : String
    , inputEmail : String
    , inputRealname : String
    , inputPassword : String
    , inputPasswordAgain : String
    , inputTitle : String

    -- UI
    , windowWidth : Int
    , windowHeight : Int
    , popupState : PopupState
    , showEditor : Bool
    }


type alias BackendModel =
    { message : String
    , currentTime : Time.Posix

    -- RANDOM
    , randomSeed : Random.Seed
    , uuidCount : Int
    , uuid : String
    , randomAtmosphericInt : Maybe Int

    -- USER
    , authenticationDict : AuthenticationDict
    , userToNoteBookDict : UserToNoteBookDict

    -- DOCUMENT
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | FETick Time.Posix
    | KeyboardMsg Keyboard.Msg
      -- CELL
    | NewCell Int
    | EditCell Int
    | ClearCell Int
    | EvalCell Int
    | InputElmCode Int String
    | UpdateNotebookTitle
    | NewNotebook
    | ChangeAppMode AppMode
    | SetCurrentNotebook Book
      -- UI
    | ChangePopup PopupState
    | GotViewport Browser.Dom.Viewport
    | GotNewWindowDimensions Int Int
      -- USER
    | SignUp
    | SignIn
    | SignOut
    | SetSignupState SignupState
    | InputUsername String
    | InputSignupUsername String
    | InputPassword String
    | InputPasswordAgain String
    | InputEmail String
    | InputTitle String
      -- ADMIN
    | AdminRunTask
    | GetUsers


type alias Cell =
    { index : Int, text : List String, value : Maybe String, cellState : CellState }


type CellState
    = CSEdit
    | CSView


type alias Book =
    { id : String
    , dirty : Bool
    , slug : String
    , author : String
    , createdAt : Time.Posix
    , updatedAt : Time.Posix
    , public : Bool
    , title : String
    , cells : List Cell
    , currentIndex : Int
    }


type alias Message =
    { txt : String, status : MessageStatus }


type MessageStatus
    = MSWhite
    | MSYellow
    | MSGreen
    | MSRed


type PopupState
    = NoPopup
    | AdminPopup
    | SignUpPopup
    | NewNotebookPopup


type SearchTerm
    = Query String


type ToBackend
    = NoOpToBackend
      -- ADMIN
    | RunTask
    | SendUsers
      -- NOTEBOOK
    | CreateNotebook String String -- authorname title
    | SaveNotebook Book
      -- USER
    | SignUpBE String String String
    | SignInBEDev
    | SignInBE String String
    | SignOutBE (Maybe String)
    | UpdateUserWith User


type BackendMsg
    = NoOpBackendMsg
    | Tick Time.Posix


type ToFrontend
    = NoOpToFrontend
    | MessageReceived Message
      -- ADMIN
    | GotUsers (List User)
      -- NOTEBOOK
    | GotNotebook Book
    | GotNotebooks (List Book)
      -- USER
    | SendMessage String
    | UserSignedIn User ClientId
    | SendUser User


type AppState
    = Loading
    | Loaded


type AppMode
    = AMWorking
    | AMEditTitle


type SignupState
    = ShowSignUpForm
    | HideSignUpForm


type alias Username =
    String


{-| Keys are notebook ids
-}
type alias NoteBookDict =
    Dict.Dict String Book


{-| UserToNotebookDict is the master dictionary for all notebooks
-}
type alias UserToNoteBookDict =
    Dict.Dict Username NoteBookDict


type DeleteItemState
    = WaitingToDeleteItem
    | CanDeleteItem (Maybe String)
