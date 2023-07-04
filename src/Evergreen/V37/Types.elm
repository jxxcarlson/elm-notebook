module Evergreen.V37.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Dict
import Evergreen.V37.Authentication
import Evergreen.V37.LiveBook.DataSet
import Evergreen.V37.LiveBook.Types
import Evergreen.V37.User
import File
import Keyboard
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


type AppMode
    = AMWorking
    | AMEditTitle


type DeleteNotebookState
    = WaitingToDeleteNotebook
    | CanDeleteNotebook


type ShowNotebooks
    = ShowUserNotebooks
    | ShowPublicNotebooks


type SignupState
    = ShowSignUpForm
    | HideSignUpForm


type PopupState
    = NoPopup
    | AdminPopup
    | ManualPopup
    | NewDataSetPopup
    | EditDataSetPopup Evergreen.V37.LiveBook.DataSet.DataSetMetaData
    | SignUpPopup
    | NewNotebookPopup
    | ViewPublicDataSetsPopup
    | ViewPrivateDataSetsPopup


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , message : String
    , messages : List Message
    , appState : AppState
    , appMode : AppMode
    , currentTime : Time.Posix
    , pressedKeys : List Keyboard.Key
    , users : List Evergreen.V37.User.User
    , inputName : String
    , inputAuthor : String
    , inputDescription : String
    , inputComments : String
    , inputData : String
    , publicDataSetMetaDataList : List Evergreen.V37.LiveBook.DataSet.DataSetMetaData
    , privateDataSetMetaDataList : List Evergreen.V37.LiveBook.DataSet.DataSetMetaData
    , kvDict : Dict.Dict String String
    , books : List Evergreen.V37.LiveBook.Types.Book
    , currentBook : Evergreen.V37.LiveBook.Types.Book
    , cellContent : String
    , currentCellIndex : Int
    , cloneReference : String
    , deleteNotebookState : DeleteNotebookState
    , showNotebooks : ShowNotebooks
    , signupState : SignupState
    , currentUser : Maybe Evergreen.V37.User.User
    , inputUsername : String
    , inputSignupUsername : String
    , inputEmail : String
    , inputRealname : String
    , inputPassword : String
    , inputPasswordAgain : String
    , inputTitle : String
    , windowWidth : Int
    , windowHeight : Int
    , popupState : PopupState
    , showEditor : Bool
    }


type alias Username =
    String


type alias NoteBookDict =
    Dict.Dict String Evergreen.V37.LiveBook.Types.Book


type alias UserToNoteBookDict =
    Dict.Dict Username NoteBookDict


type alias NotebookRecord =
    { id : String
    , author : String
    , public : Bool
    }


type alias BackendModel =
    { message : String
    , currentTime : Time.Posix
    , randomSeed : Random.Seed
    , uuidCount : Int
    , uuid : String
    , randomAtmosphericInt : Maybe Int
    , dataSetLibrary : Dict.Dict String Evergreen.V37.LiveBook.DataSet.DataSet
    , userToNoteBookDict : UserToNoteBookDict
    , slugDict : Dict.Dict String NotebookRecord
    , authenticationDict : Evergreen.V37.Authentication.AuthenticationDict
    }


type DataSetDescription
    = PublicDatasets
    | UserDatasets String


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg
    | FETick Time.Posix
    | KeyboardMsg Keyboard.Msg
    | StringDataRequested Int String
    | StringDataSelected Int String File.File
    | StringDataLoaded String Int String String
    | InputName String
    | InputDescription String
    | InputComments String
    | InputData String
    | InputAuthor String
    | AskToListDataSets DataSetDescription
    | AskToSaveDataSet Evergreen.V37.LiveBook.DataSet.DataSetMetaData
    | AskToCreateDataSet
    | AskToDeleteDataSet Evergreen.V37.LiveBook.DataSet.DataSetMetaData
    | ToggleCellLock Evergreen.V37.LiveBook.Types.Cell
    | NewCell Int
    | DeleteCell Int
    | EditCell Int
    | ClearCell Int
    | EvalCell Int
    | InputElmCode Int String
    | UpdateNotebookTitle
    | NewNotebook
    | ProposeDeletingNotebook
    | CancelDeleteNotebook
    | ChangeAppMode AppMode
    | TogglePublic
    | ClearNotebookValues
    | SetCurrentNotebook Evergreen.V37.LiveBook.Types.Book
    | CloneNotebook
    | PullNotebook
    | SetShowNotebooksState ShowNotebooks
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
    | InputTitle String
    | InputCloneReference String
    | AdminRunTask
    | GetUsers


type ToBackend
    = NoOpToBackend
    | RunTask
    | SendUsers
    | DeleteDataSet Evergreen.V37.LiveBook.DataSet.DataSetMetaData
    | SaveDataSet Evergreen.V37.LiveBook.DataSet.DataSetMetaData
    | GetListOfDataSets DataSetDescription
    | CreateDataSet Evergreen.V37.LiveBook.DataSet.DataSet
    | GetData Int String String
    | GetDataSetForDownload String
    | CreateNotebook String String
    | SaveNotebook Evergreen.V37.LiveBook.Types.Book
    | DeleteNotebook Evergreen.V37.LiveBook.Types.Book
    | GetClonedNotebook String String
    | GetPulledNotebook String String String String
    | UpdateSlugDict Evergreen.V37.LiveBook.Types.Book
    | GetUsersNotebooks String
    | GetPublicNotebooks String
    | SignUpBE String String String
    | SignInBEDev
    | SignInBE String String
    | SignOutBE (Maybe String)
    | UpdateUserWith Evergreen.V37.User.User


type BackendMsg
    = NoOpBackendMsg
    | Tick Time.Posix


type ToFrontend
    = NoOpToFrontend
    | MessageReceived Message
    | GotUsers (List Evergreen.V37.User.User)
    | GotListOfPublicDataSets (List Evergreen.V37.LiveBook.DataSet.DataSetMetaData)
    | GotListOfPrivateDataSets (List Evergreen.V37.LiveBook.DataSet.DataSetMetaData)
    | GotData Int String Evergreen.V37.LiveBook.DataSet.DataSet
    | GotDataForDownload Evergreen.V37.LiveBook.DataSet.DataSet
    | GotNotebook Evergreen.V37.LiveBook.Types.Book
    | GotNotebooks (List Evergreen.V37.LiveBook.Types.Book)
    | SendMessage String
    | UserSignedIn Evergreen.V37.User.User Lamdera.ClientId
    | SendUser Evergreen.V37.User.User
