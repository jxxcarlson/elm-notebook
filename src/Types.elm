module Types exposing (..)

import Authentication exposing (AuthenticationDict)
import Browser exposing (UrlRequest)
import Browser.Dom
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import File exposing (File)
import Http
import Json.Decode
import Keyboard
import Lamdera exposing (ClientId)
import Notebook.Book exposing (Book)
import Notebook.Cell exposing (Cell, CellState(..), CellValue(..))
import Notebook.DataSet
import Notebook.ErrorReporter
import Notebook.Types
import Random
import Time
import Url exposing (Url)
import User exposing (User)


type alias FrontendModel =
    { -- SYSTEM
      key : Key
    , url : Url
    , message : String
    , messages : List Message
    , appState : AppState
    , appMode : AppMode
    , currentTime : Time.Posix
    , tickCount : Int
    , clockState : ClockState
    , pressedKeys : List Keyboard.Key
    , randomSeed : Random.Seed
    , randomProbabilities : List Float
    , probabilityVectorLength : Int

    -- ADMIN
    , users : List User

    -- INPUT FIELDS
    , inputName : String
    , inputIdentifier : String
    , inputAuthor : String
    , inputDescription : String
    , inputComments : String
    , inputData : String
    , inputInitialStateValue : String

    -- DATA
    , publicDataSetMetaDataList : List Notebook.DataSet.DataSetMetaData
    , privateDataSetMetaDataList : List Notebook.DataSet.DataSetMetaData

    -- NOTEBOOKS
    , report : List Notebook.ErrorReporter.MessageItem
    , replData : Maybe Notebook.Types.ReplData
    , evalState : Notebook.Types.EvalState

    -- NOTEBOOKS II
    , kvDict : Dict String String
    , books : List Book
    , currentBook : Book
    , cellContent : String
    , currentCellIndex : Int
    , cloneReference : String
    , deleteNotebookState : DeleteNotebookState
    , showNotebooks : ShowNotebooks

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


type ClockState
    = ClockRunning
    | ClockStopped
    | ClockPaused


type alias BackendModel =
    { message : String
    , currentTime : Time.Posix

    -- RANDOM
    , randomSeed : Random.Seed
    , uuidCount : Int
    , uuid : String
    , randomAtmosphericInt : Maybe Int

    -- NOTEBOOK
    , dataSetLibrary : Dict String Notebook.DataSet.DataSet
    , userToNoteBookDict : UserToNoteBookDict
    , slugDict : Dict.Dict String NotebookRecord -- keys are slugs, values are notebook ids

    -- USER
    , authenticationDict : AuthenticationDict

    -- DOCUMENT
    }


type ShowNotebooks
    = ShowUserNotebooks
    | ShowPublicNotebooks


type DeleteNotebookState
    = WaitingToDeleteNotebook
    | CanDeleteNotebook


type alias NotebookRecord =
    { id : String, author : String, public : Bool }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | FETick Time.Posix
    | KeyboardMsg Keyboard.Msg
    | GetRandomProbabilities Int
    | GotRandomProbabilities (List Float)
      -- FILE
    | StringDataRequested Int String -- int is the cell index, string is the variable name
    | StringDataSelected Int String File
    | StringDataLoaded String Int String String
      -- INPUT FIELDS
    | InputName String
    | InputIdentifier String
    | InputDescription String
    | InputComments String
    | InputData String
    | InputAuthor String
    | InputInitialStateValue String
      -- Notebook
    | GotReply (Result Http.Error String)
    | ReceivedFromJS String
      -- DATA
    | AskToListDataSets DataSetDescription
    | AskToSaveDataSet Notebook.DataSet.DataSetMetaData
    | AskToCreateDataSet
    | AskToDeleteDataSet Notebook.DataSet.DataSetMetaData
      -- CELL
    | ToggleCellLock Cell
    | NewCodeCell Int
    | NewMarkdownCell Int
    | DeleteCell Int
    | EditCell Cell
    | ClearCell Int
    | EvalCell Int
    | InputElmCode Int String
    | UpdateNotebookTitle
    | NewNotebook
    | ProposeDeletingNotebook
    | CancelDeleteNotebook
    | ChangeAppMode AppMode
    | SetClock ClockState
    | Reset
    | TogglePublic
    | ClearNotebookValues
    | SetCurrentNotebook Book
    | CloneNotebook
    | PullNotebook
    | ExportNotebook
    | SetShowNotebooksState ShowNotebooks
    | ImportRequested
    | ImportSelected File
    | ImportLoaded String
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
    | InputCloneReference String
      -- ADMIN
    | AdminRunTask
    | GetUsers


type alias Message =
    { txt : String, status : MessageStatus }


type DataSetDescription
    = PublicDatasets
    | UserDatasets String


type MessageStatus
    = MSWhite
    | MSYellow
    | MSGreen
    | MSRed


type PopupState
    = NoPopup
    | AdminPopup
    | ManualPopup
    | NewDataSetPopup
    | EditDataSetPopup Notebook.DataSet.DataSetMetaData
    | SignUpPopup
    | NewNotebookPopup
    | StateEditorPopup
    | ViewPublicDataSetsPopup
    | ViewPrivateDataSetsPopup


type SearchTerm
    = Query String


type ToBackend
    = NoOpToBackend
    | GetRandomSeed
      -- ADMIN
    | RunTask
    | SendUsers
      -- DATA
    | DeleteDataSet Notebook.DataSet.DataSetMetaData
    | SaveDataSet Notebook.DataSet.DataSetMetaData
    | GetListOfDataSets DataSetDescription
    | CreateDataSet Notebook.DataSet.DataSet
    | GetData Int String String -- Int is the index of the requesting cell,
      -- String1 is the DataSet identifier, String2 is the variable in which to store it.
    | GetDataSetForDownload String -- Int is the index of the requesting cell,
      -- NOTEBOOK
    | CreateNotebook String String -- authorname title
    | ImportNewBook String Book
    | SaveNotebook Book
    | DeleteNotebook Book
    | GetPublicNotebook String
    | GetClonedNotebook String String -- username slug
    | GetPulledNotebook String String String String -- username origin slug id
    | UpdateSlugDict Book
    | GetUsersNotebooks String -- username
    | GetPublicNotebooks (Maybe Book) String --
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
    | GotRandomSeed Random.Seed
      -- ADMIN
    | GotUsers (List User)
      -- DATA
    | GotListOfPublicDataSets (List Notebook.DataSet.DataSetMetaData)
    | GotListOfPrivateDataSets (List Notebook.DataSet.DataSetMetaData)
    | GotData Int String Notebook.DataSet.DataSet
    | GotDataForDownload Notebook.DataSet.DataSet
      -- NOTEBOOK
    | GotNotebook Book
    | GotPublicNotebook Book
    | GotNotebooks (Maybe Book) (List Book)
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
