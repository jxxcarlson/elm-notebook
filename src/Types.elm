module Types exposing (..)

import Authentication exposing (AuthenticationDict)
import Browser exposing (UrlRequest)
import Browser.Dom
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import File exposing (File)
import Keyboard
import Lamdera exposing (ClientId)
import LiveBook.DataSet
import LiveBook.State
import LiveBook.Types exposing (Book, Cell, CellState(..), CellValue(..), VisualType(..))
import Random
import Time
import Url exposing (Url)
import User exposing (User)
import Value exposing (Value)


type alias FrontendModel =
    { key : Key
    , url : Url
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
    , inputFastTickInterval : String
    , inputStateExpression : String
    , inputStateBindings : String
    , inputStopExpression : String
    , inputValuesToKeep : String

    -- DATA
    , publicDataSetMetaDataList : List LiveBook.DataSet.DataSetMetaData
    , privateDataSetMetaDataList : List LiveBook.DataSet.DataSetMetaData

    -- NOTEBOOKS
    , kvDict : Dict String String
    , books : List Book
    , currentBook : Book
    , cellContent : String
    , currentCellIndex : Int
    , cloneReference : String
    , deleteNotebookState : DeleteNotebookState
    , showNotebooks : ShowNotebooks
    , valueDict : Dict String Value
    , nextStateRecord : Maybe LiveBook.State.NextStateRecord
    , state : LiveBook.State.MState
    , svgList : List String
    , valuesToKeep : Int

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
    , dataSetLibrary : Dict String LiveBook.DataSet.DataSet
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
    | FastTick Time.Posix
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
    | InputFastTickInterval String
    | InputStateExpression String
    | InputStateBindings String
    | InputStopExpression String
    | InputValuesToKeep String
      -- DATA
    | AskToListDataSets DataSetDescription
    | AskToSaveDataSet LiveBook.DataSet.DataSetMetaData
    | AskToCreateDataSet
    | AskToDeleteDataSet LiveBook.DataSet.DataSetMetaData
      -- CELL
    | ToggleCellLock Cell
    | NewCell Int
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
    | SetState
    | Reset
    | Start
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
    | EditDataSetPopup LiveBook.DataSet.DataSetMetaData
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
    | DeleteDataSet LiveBook.DataSet.DataSetMetaData
    | SaveDataSet LiveBook.DataSet.DataSetMetaData
    | GetListOfDataSets DataSetDescription
    | CreateDataSet LiveBook.DataSet.DataSet
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
    | GotListOfPublicDataSets (List LiveBook.DataSet.DataSetMetaData)
    | GotListOfPrivateDataSets (List LiveBook.DataSet.DataSetMetaData)
    | GotData Int String LiveBook.DataSet.DataSet
    | GotDataForDownload LiveBook.DataSet.DataSet
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
