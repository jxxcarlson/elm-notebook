module Frontend exposing (app)

import Authentication
import Browser exposing (UrlRequest(..))
import Browser.Dom
import Browser.Events
import Browser.Navigation as Nav
import Frontend.Authentication
import Frontend.Message
import Html exposing (Html)
import Keyboard
import Lamdera exposing (sendToBackend)
import List.Extra
import LiveBook.Book
import LiveBook.Cell
import LiveBook.Update
import Loading
import Random
import Task
import Time
import Types exposing (..)
import Url exposing (Url)
import User
import View.Main


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = subscriptions
        , view = view
        }


subscriptions model =
    Sub.batch
        [ Browser.Events.onResize GotNewWindowDimensions
        , Time.every 5000 FETick
        , Sub.map KeyboardMsg Keyboard.subscriptions
        ]


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , url = url
      , message = "Welcome!"
      , messages = []
      , appState = Loading
      , appMode = AMWorking
      , currentTime = Time.millisToPosix 0
      , pressedKeys = []

      -- ADMIN
      , users = []

      -- CELLS
      , books = []
      , currentBook = LiveBook.Book.scratchPad
      , cellContent = ""
      , currentCellIndex = 0
      , cloneReference = ""

      -- UI
      , windowWidth = 600
      , windowHeight = 900
      , popupState = NoPopup
      , showEditor = False

      -- USER
      , signupState = HideSignUpForm
      , currentUser = Nothing
      , inputUsername = ""
      , inputSignupUsername = ""
      , inputRealname = ""
      , inputPassword = ""
      , inputPasswordAgain = ""
      , inputEmail = ""
      , inputTitle = ""
      }
    , setupWindow
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        NoOpFrontendMsg ->
            ( model, Cmd.none )

        KeyboardMsg keyMsg ->
            let
                pressedKeys =
                    Keyboard.update keyMsg model.pressedKeys

                newModel =
                    if List.member Keyboard.Control pressedKeys && List.member Keyboard.Enter pressedKeys then
                        LiveBook.Update.evalCell_ model.currentCellIndex model

                    else
                        model
            in
            ( { newModel
                | pressedKeys = pressedKeys
              }
            , Cmd.none
            )

        FETick time ->
            let
                saveNoteBookCmd =
                    if model.currentBook.dirty then
                        sendToBackend (SaveNotebook model.currentBook)

                    else
                        Cmd.none
            in
            ( { model | currentTime = time }, saveNoteBookCmd )

        -- NAV
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model, Cmd.none )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        -- SYSTEM
        GotViewport vp ->
            case model.appState of
                Types.Loaded ->
                    updateWithViewport vp model

                Types.Loading ->
                    let
                        -- First we have to get the window width and height
                        w =
                            round vp.viewport.width

                        h =
                            round vp.viewport.height
                    in
                    -- Then we set the appState to Loaded
                    ( { model
                        | windowWidth = w
                        , windowHeight = h
                        , appState = Types.Loaded
                      }
                    , Cmd.none
                    )

        GotNewWindowDimensions w h ->
            ( { model | windowWidth = w, windowHeight = h }, Cmd.none )

        ChangePopup popupState ->
            case popupState of
                NoPopup ->
                    ( { model | popupState = NoPopup }, Cmd.none )

                NewNotebookPopup ->
                    if model.popupState == NewNotebookPopup then
                        ( { model | popupState = NoPopup }, Cmd.none )

                    else
                        ( { model | popupState = NewNotebookPopup }, Cmd.none )

                ManualPopup ->
                    if model.popupState == ManualPopup then
                        ( { model | popupState = NoPopup }, Cmd.none )

                    else
                        ( { model | popupState = ManualPopup }, Cmd.none )

                SignUpPopup ->
                    if model.popupState == SignUpPopup then
                        ( { model | popupState = NoPopup }, Cmd.none )

                    else
                        ( { model
                            | popupState = SignUpPopup
                            , inputUsername = ""
                            , inputEmail = ""
                            , inputPassword = ""
                            , inputPasswordAgain = ""
                          }
                        , Cmd.none
                        )

                AdminPopup ->
                    if model.popupState == AdminPopup then
                        ( { model | popupState = NoPopup }, Cmd.none )

                    else
                        ( { model | popupState = AdminPopup }, sendToBackend SendUsers )

        -- SIGN UP, IN, OUT
        SetSignupState state ->
            Frontend.Authentication.setSignupState model state

        SignUp ->
            Frontend.Authentication.signUp model

        SignIn ->
            if String.length model.inputPassword >= 8 then
                ( model
                , sendToBackend (SignInBE model.inputUsername (Authentication.encryptForTransit model.inputPassword))
                )

            else
                ( { model | message = "Password must be at least 8 letters long." }, Cmd.none )

        InputUsername str ->
            ( { model | inputUsername = str }, Cmd.none )

        InputSignupUsername str ->
            ( { model | inputSignupUsername = str }, Cmd.none )

        InputEmail str ->
            ( { model | inputEmail = str }, Cmd.none )

        InputPassword str ->
            ( { model | inputPassword = str }, Cmd.none )

        InputPasswordAgain str ->
            ( { model | inputPasswordAgain = str }, Cmd.none )

        InputTitle str ->
            ( { model | inputTitle = str }, Cmd.none )

        InputCloneReference str ->
            ( { model | cloneReference = str }, Cmd.none )

        SignOut ->
            ( { model
                | currentUser = Nothing
                , message = "Signed out"
                , inputUsername = ""
                , inputPassword = ""
              }
            , Cmd.batch [ Nav.pushUrl model.key "/", sendToBackend (SaveNotebook model.currentBook) ]
            )

        -- CELLS, NOTEBOOKS
        CloneNotebook ->
            case model.currentUser of
                Nothing ->
                    ( model, Cmd.none )

                Just user ->
                    ( model, sendToBackend (GetClonedNotebook user.username model.cloneReference) )

        SetCurrentNotebook book ->
            case model.currentUser of
                Nothing ->
                    ( model, Cmd.none )

                Just user_ ->
                    let
                        user =
                            { user_ | currentNotebookId = Just book.id }
                    in
                    ( { model | currentUser = Just user, currentBook = LiveBook.Book.initializeCellState book }
                    , sendToBackend (UpdateUserWith user)
                    )

        TogglePublic ->
            let
                oldBook =
                    model.currentBook

                newBook =
                    { oldBook | public = not oldBook.public }
            in
            ( { model | currentBook = newBook, books = List.Extra.setIf (\b -> b.id == newBook.id) newBook model.books }, sendToBackend (SaveNotebook newBook) )

        NewNotebook ->
            case model.currentUser of
                Nothing ->
                    ( model, Cmd.none )

                Just user ->
                    ( model, sendToBackend (CreateNotebook user.username "New Notebook") )

        ChangeAppMode mode ->
            case mode of
                AMEditTitle ->
                    ( { model | appMode = mode, inputTitle = model.currentBook.title }, Cmd.none )

                _ ->
                    ( { model | appMode = mode }, Cmd.none )

        UpdateNotebookTitle ->
            let
                oldBook =
                    model.currentBook

                compress str =
                    str |> String.toLower |> String.replace " " "-"

                newBook =
                    { oldBook | title = model.inputTitle, slug = compress (oldBook.author ++ "." ++ model.inputTitle) }
            in
            ( { model
                | appMode = AMWorking
                , currentBook = newBook
                , books = List.Extra.setIf (\b -> b.id == newBook.id) newBook model.books
              }
            , Cmd.batch
                [ sendToBackend (SaveNotebook newBook)
                , sendToBackend (UpdateSlugDict newBook)
                ]
            )

        InputElmCode index str ->
            ( LiveBook.Update.updateCellText model index str, Cmd.none )

        NewCell index ->
            LiveBook.Update.makeNewCell model index

        EditCell index ->
            LiveBook.Update.editCell model index

        ClearCell index ->
            LiveBook.Update.clearCell model index

        EvalCell index ->
            LiveBook.Update.evalCell model index

        -- NOTEBOOKS
        -- ADMIN
        AdminRunTask ->
            ( model, sendToBackend RunTask )

        GetUsers ->
            ( model, sendToBackend SendUsers )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        -- ADMIN
        GotUsers users ->
            ( { model | users = users }, Cmd.none )

        -- USER
        SendMessage message ->
            ( { model | message = message }, Cmd.none )

        MessageReceived message ->
            Frontend.Message.received model message

        UserSignedIn user _ ->
            ( { model | currentUser = Just user, popupState = Types.NoPopup }, Cmd.none )

        SendUser user ->
            if user.username == "guest" then
                ( { model | currentUser = Just user, message = "" }, Cmd.none )

            else
                ( { model | currentUser = Just user, message = "" }, Cmd.none )

        -- NOTEBOOKS
        GotNotebook book_ ->
            let
                book =
                    LiveBook.Book.initializeCellState book_
            in
            ( { model | currentBook = book, books = book :: model.books }, Cmd.none )

        GotNotebooks books ->
            ( { model | books = books }, Cmd.none )


view : Model -> { title : String, body : List (Html.Html FrontendMsg) }
view model =
    { title = "Elm Livebook"
    , body =
        [ View.Main.view model ]
    }



--HELPERS


updateWithViewport : Browser.Dom.Viewport -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
updateWithViewport vp model =
    let
        w =
            round vp.viewport.width

        h =
            round vp.viewport.height
    in
    ( { model
        | windowWidth = w
        , windowHeight = h
      }
    , Cmd.none
    )


setupWindow : Cmd FrontendMsg
setupWindow =
    Task.perform GotViewport Browser.Dom.getViewport
