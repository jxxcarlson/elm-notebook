module Types exposing (..)

import Authentication exposing (AuthenticationDict)
import Browser exposing (UrlRequest)
import Browser.Dom
import Browser.Navigation exposing (Key)
import Bytes
import Dict exposing (Dict)
import File exposing (File)
import Http
import Lamdera exposing (ClientId)
import Loading
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
    , currentTime : Time.Posix

    -- ADMIN
    , users : List User

    -- IMAGE
    , randomize : Bool
    , randomSeed : Random.Seed
    , pasting : PastingState
    , imageData : Maybe Bytes.Bytes
    , clipboardImageDataPlus : Maybe ClipboardImageDataPlus
    , imageFileName : String
    , imageUrl : Maybe String
    , imageRecord : Maybe ImageRecord
    , imageIdentifier : String
    , imageRecords : List ImageRecord
    , inputImageQuery : String
    , inputImageName : String
    , grabImageUrlInput : String
    , inputImageMetadata : String
    , currentImageIdentifier : Maybe String
    , deleteItemState : DeleteItemState
    , imageDict : Maybe ImageDict
    , publicImageUrl : Maybe String
    , file : Maybe File
    , loading : Loading.LoadingState

    -- USER
    , signupState : SignupState
    , currentUser : Maybe User
    , inputUsername : String
    , inputSignupUsername : String
    , inputEmail : String
    , inputRealname : String
    , inputPassword : String
    , inputPasswordAgain : String

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
    , randomAtmosphericInt : Maybe Int

    -- USER
    , authenticationDict : AuthenticationDict

    -- DOCUMENT
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
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
      -- ADMIN
    | AdminRunTask
    | GetUsers


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


type SearchTerm
    = Query String


type ToBackend
    = NoOpToBackend
      -- ADMIN
    | RunTask
    | SendUsers
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
      -- USER
    | SendMessage String
    | UserSignedIn User ClientId
    | SendUser User



type AppState
    = Loading
    | Loaded


type SignupState
    = ShowSignUpForm
    | HideSignUpForm


type alias Username =
    String



-- IMAGE


type PastingState
    = PastingStart
    | PastingDone


type alias ClipboardImageDataAux =
    { imageSize : Int
    , mimeType : String
    , content : String
    }


type alias ClipboardImageData =
    { imageSize : Int
    , mimeType : String
    , bytes : Bytes.Bytes
    }


type alias ClipboardImageDataPlus =
    { filename : String
    , username : String
    , imageSize : Int
    , mimeType : String
    , bytes : Bytes.Bytes
    }


type ImageSource
    = ImageFromFile
    | ImageFromClipboard


{-| Keys are image identifiers
-}
type alias ImageDict =
    Dict.Dict String ImageRecord


type alias ImageUserDict =
    Dict.Dict Username ImageDict


type alias ImageRecord =
    { identifier : String
    , id : String
    , username : String
    , filename : String
    , urlList : List String
    , dateUploaded : String
    , timeUploaded : Time.Posix
    , metaData : Dict String String
    , public : Bool
    }


type alias CloudFlareUrlDataPlus =
    { clientId : ClientId
    , id : String
    , uploadUrl : String
    , success : Bool
    , errors : List String
    , messages : List String
    , imageSource : ImageSource
    }


type alias CloudFlareErrorData =
    { success : Bool
    , errors : List CloudFlareErrorRecord
    }


type alias CloudFlareErrorRecord =
    { code : Int, message : String }


type alias CloudFlarePostImageResponseData =
    { id : String
    , filename : String
    , uploadedAt : String
    , requireSignedURLs : Bool
    , variants : List String
    , success : Bool
    , errors : List String
    , messages : List String
    }


type alias CloudFlareUrlData =
    { id : String
    , uploadUrl : String
    , success : Bool
    , errors : List String
    , messages : List String
    }


type alias ImageServerData =
    { username : String
    , filename : String
    , url : String
    }


type DeleteItemState
    = WaitingToDeleteItem
    | CanDeleteItem (Maybe String)
