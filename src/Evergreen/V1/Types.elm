module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V1.Authentication
import Evergreen.V1.LiveBook.Types
import Evergreen.V1.User
import Lamdera
import Random
import Time
import Url


type MessageStatus
    = MSWhite
    | MSYellow
    | MSGreen
    | MSRed


type alias Message =
    { txt : String
    , status : MessageStatus
    }


type AppState
    = Loading
    | Loaded


type SignupState
    = ShowSignUpForm
    | HideSignUpForm


type PopupState
    = NoPopup
    | AdminPopup
    | SignUpPopup


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , message : String
    , messages : List Message
    , appState : AppState
    , currentTime : Time.Posix
    , users : List Evergreen.V1.User.User
    , books : List Evergreen.V1.LiveBook.Types.Book
    , currentBook : Evergreen.V1.LiveBook.Types.Book
    , cellContent : String
    , signupState : SignupState
    , currentUser : Maybe Evergreen.V1.User.User
    , inputUsername : String
    , inputSignupUsername : String
    , inputEmail : String
    , inputRealname : String
    , inputPassword : String
    , inputPasswordAgain : String
    , windowWidth : Int
    , windowHeight : Int
    , popupState : PopupState
    , showEditor : Bool
    }


type alias BackendModel =
    { message : String
    , currentTime : Time.Posix
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , authenticationDict : Evergreen.V1.Authentication.AuthenticationDict
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg
    | NewCell Int
    | EditCell Int
    | ClearCell Int
    | EvalCell Int
    | InputElmCode String
    | ChangePopup PopupState
    | GotViewport Browser.Dom.Viewport
    | GotNewWindowDimensions Int Int
    | SignUp
    | SignIn
    | SignOut
    | SetSignupState SignupState
    | InputUsername String
    | InputSignupUsername String
    | InputPassword String
    | InputPasswordAgain String
    | InputEmail String
    | AdminRunTask
    | GetUsers


type ToBackend
    = NoOpToBackend
    | RunTask
    | SendUsers
    | SignUpBE String String String
    | SignInBEDev
    | SignInBE String String
    | SignOutBE (Maybe String)
    | UpdateUserWith Evergreen.V1.User.User


type BackendMsg
    = NoOpBackendMsg
    | Tick Time.Posix


type ToFrontend
    = NoOpToFrontend
    | MessageReceived Message
    | GotUsers (List Evergreen.V1.User.User)
    | SendMessage String
    | UserSignedIn Evergreen.V1.User.User Lamdera.ClientId
    | SendUser Evergreen.V1.User.User
