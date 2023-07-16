module Evergreen.V102.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Dict
import Evergreen.V102.Authentication
import Evergreen.V102.LiveBook.DataSet
import Evergreen.V102.LiveBook.State
import Evergreen.V102.LiveBook.Types
import Evergreen.V102.User
import Evergreen.V102.Value
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


type ClockState
    = ClockRunning
    | ClockStopped
    | ClockPaused


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
    | EditDataSetPopup Evergreen.V102.LiveBook.DataSet.DataSetMetaData
    | SignUpPopup
    | NewNotebookPopup
    | StateEditorPopup
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
    , tickCount : Int
    , fastTickInterval : Float
    , clockState : ClockState
    , pressedKeys : List Keyboard.Key
    , randomSeed : Random.Seed
    , randomProbabilities : List Float
    , probabilityVectorLength : Int
    , users : List Evergreen.V102.User.User
    , inputName : String
    , inputIdentifier : String
    , inputAuthor : String
    , inputDescription : String
    , inputComments : String
    , inputData : String
    , inputInitialStateValue : String
    , inputFastTickInterval : String
    , inputStateExpression : String
    , inputStateBindings : String
    , inputStopExpression : String
    , publicDataSetMetaDataList : List Evergreen.V102.LiveBook.DataSet.DataSetMetaData
    , privateDataSetMetaDataList : List Evergreen.V102.LiveBook.DataSet.DataSetMetaData
    , kvDict : Dict.Dict String String
    , books : List Evergreen.V102.LiveBook.Types.Book
    , currentBook : Evergreen.V102.LiveBook.Types.Book
    , cellContent : String
    , currentCellIndex : Int
    , cloneReference : String
    , deleteNotebookState : DeleteNotebookState
    , showNotebooks : ShowNotebooks
    , valueDict : Dict.Dict String Evergreen.V102.Value.Value
    , nextStateRecord : Maybe Evergreen.V102.LiveBook.State.NextStateRecord
    , state : Evergreen.V102.LiveBook.State.MState
    , signupState : SignupState
    , currentUser : Maybe Evergreen.V102.User.User
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
    Dict.Dict String Evergreen.V102.LiveBook.Types.Book


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
    , dataSetLibrary : Dict.Dict String Evergreen.V102.LiveBook.DataSet.DataSet
    , userToNoteBookDict : UserToNoteBookDict
    , slugDict : Dict.Dict String NotebookRecord
    , authenticationDict : Evergreen.V102.Authentication.AuthenticationDict
    }


type DataSetDescription
    = PublicDatasets
    | UserDatasets String


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg
    | FETick Time.Posix
    | FastTick Time.Posix
    | KeyboardMsg Keyboard.Msg
    | GetRandomProbabilities Int
    | GotRandomProbabilities (List Float)
    | StringDataRequested Int String
    | StringDataSelected Int String File.File
    | StringDataLoaded String Int String String
    | InputName String
    | InputIdentifier String
    | InputDescription String
    | InputComments String
    | InputData String
    | InputAuthor String
    | InputInitialStateValue String
    | InputFastTickInterval String
    | InputStateExpression String
    | InputStateBindings String
    | InputStopExpression String
    | AskToListDataSets DataSetDescription
    | AskToSaveDataSet Evergreen.V102.LiveBook.DataSet.DataSetMetaData
    | AskToCreateDataSet
    | AskToDeleteDataSet Evergreen.V102.LiveBook.DataSet.DataSetMetaData
    | ToggleCellLock Evergreen.V102.LiveBook.Types.Cell
    | NewCell Int
    | DeleteCell Int
    | EditCell Evergreen.V102.LiveBook.Types.Cell
    | ClearCell Int
    | EvalCell Int
    | InputElmCode Int String
    | UpdateNotebookTitle
    | NewNotebook
    | ProposeDeletingNotebook
    | CancelDeleteNotebook
    | ChangeAppMode AppMode
    | SetClock ClockState
    | SetState
    | Reset
    | TogglePublic
    | ClearNotebookValues
    | SetCurrentNotebook Evergreen.V102.LiveBook.Types.Book
    | CloneNotebook
    | PullNotebook
    | ExportNotebook
    | SetShowNotebooksState ShowNotebooks
    | ImportRequested
    | ImportSelected File.File
    | ImportLoaded String
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
    | GetRandomSeed
    | RunTask
    | SendUsers
    | DeleteDataSet Evergreen.V102.LiveBook.DataSet.DataSetMetaData
    | SaveDataSet Evergreen.V102.LiveBook.DataSet.DataSetMetaData
    | GetListOfDataSets DataSetDescription
    | CreateDataSet Evergreen.V102.LiveBook.DataSet.DataSet
    | GetData Int String String
    | GetDataSetForDownload String
    | CreateNotebook String String
    | ImportNewBook String Evergreen.V102.LiveBook.Types.Book
    | SaveNotebook Evergreen.V102.LiveBook.Types.Book
    | DeleteNotebook Evergreen.V102.LiveBook.Types.Book
    | GetPublicNotebook String
    | GetClonedNotebook String String
    | GetPulledNotebook String String String String
    | UpdateSlugDict Evergreen.V102.LiveBook.Types.Book
    | GetUsersNotebooks String
    | GetPublicNotebooks String
    | SignUpBE String String String
    | SignInBEDev
    | SignInBE String String
    | SignOutBE (Maybe String)
    | UpdateUserWith Evergreen.V102.User.User


type BackendMsg
    = NoOpBackendMsg
    | Tick Time.Posix


type ToFrontend
    = NoOpToFrontend
    | MessageReceived Message
    | GotRandomSeed Random.Seed
    | GotUsers (List Evergreen.V102.User.User)
    | GotListOfPublicDataSets (List Evergreen.V102.LiveBook.DataSet.DataSetMetaData)
    | GotListOfPrivateDataSets (List Evergreen.V102.LiveBook.DataSet.DataSetMetaData)
    | GotData Int String Evergreen.V102.LiveBook.DataSet.DataSet
    | GotDataForDownload Evergreen.V102.LiveBook.DataSet.DataSet
    | GotNotebook Evergreen.V102.LiveBook.Types.Book
    | GotPublicNotebook Evergreen.V102.LiveBook.Types.Book
    | GotNotebooks (List Evergreen.V102.LiveBook.Types.Book)
    | SendMessage String
    | UserSignedIn Evergreen.V102.User.User Lamdera.ClientId
    | SendUser Evergreen.V102.User.User
