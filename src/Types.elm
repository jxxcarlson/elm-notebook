module Types exposing (..)

import Authentication exposing (AuthenticationDict)
import Browser exposing (UrlRequest)
import Browser.Dom
import Browser.Navigation exposing (Key)
import Bytes
import Dict exposing (Dict)
import Element
import File exposing (File)
import Html exposing (Html)
import Keyboard
import Lamdera exposing (ClientId)
import LiveBook.DataSet
import LiveBook.Types exposing (Book, Cell, CellState(..), CellValue(..), VisualType(..))
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

    -- INPUT FIELDS
    , inputName : String
    , inputAuthor : String
    , inputDescription : String
    , inputComments : String
    , inputData : String

    -- DATA
    , dataSetMetaDataList : List LiveBook.DataSet.DataSetMetaData

    -- NOTEBOOKS
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
    | KeyboardMsg Keyboard.Msg
      -- FILE
    | StringDataRequested Int String -- int is the cell index, string is the variable name
    | StringDataSelected Int String File
    | StringDataLoaded String Int String String
      -- INPUT FIELDS
    | InputName String
    | InputDescription String
    | InputComments String
    | InputData String
    | InputAuthor String
      -- DATA
    | AskToListDataSets DataSetDescription
    | AskToCreateDataSet
      -- CELL
    | ToggleCellLock Cell
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
    | SetCurrentNotebook Book
    | CloneNotebook
    | PullNotebook
    | SetShowNotebooksState ShowNotebooks
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
    | DataSetPopup
    | SignUpPopup
    | NewNotebookPopup
    | ViewDataSetsPopup


type SearchTerm
    = Query String


type ToBackend
    = NoOpToBackend
      -- ADMIN
    | RunTask
    | SendUsers
      -- DATA
    | GetListOfDataSets DataSetDescription
    | CreateDataSet LiveBook.DataSet.DataSet
    | GetData Int String String -- Int is the index of the requesting cell,
      -- String1 is the DataSet identifier, String2 is the variable in which to store it.
    | GetDataSetForDownload String -- Int is the index of the requesting cell,
      -- NOTEBOOK
    | CreateNotebook String String -- authorname title
    | SaveNotebook Book
    | DeleteNotebook Book
    | GetClonedNotebook String String -- username slug
    | GetPulledNotebook String String String String -- username origin slug id
    | UpdateSlugDict Book
    | GetUsersNotebooks String -- username
    | GetPublicNotebooks String --
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
      -- DATA
    | GotListOfDataSets (List LiveBook.DataSet.DataSetMetaData)
    | GotData Int String LiveBook.DataSet.DataSet
    | GotDataForDownload LiveBook.DataSet.DataSet
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
