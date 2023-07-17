module Frontend exposing (app)

import Authentication
import BackendHelper
import Browser exposing (UrlRequest(..))
import Browser.Dom
import Browser.Events
import Browser.Navigation as Nav
import Dict
import Eval
import File
import File.Download
import File.Select
import Frontend.Authentication
import Frontend.Message
import Html exposing (Html)
import Keyboard
import Lamdera exposing (sendToBackend)
import List.Extra
import LiveBook.Action
import LiveBook.Book
import LiveBook.Cell
import LiveBook.Codec
import LiveBook.Config
import LiveBook.DataSet
import LiveBook.Eval
import LiveBook.Parser
import LiveBook.State
import LiveBook.Types exposing (Book)
import LiveBook.Update
import Loading
import Navigation
import Predicate
import Random
import Task
import Time
import Types exposing (..)
import Url exposing (Url)
import User
import Value
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
        , Time.every 3000 FETick
        , Time.every model.fastTickInterval FastTick
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
      , tickCount = 0
      , clockState = ClockStopped
      , fastTickInterval = LiveBook.Config.fastTickInterval
      , pressedKeys = []
      , randomSeed = Random.initialSeed 1234
      , randomProbabilities = []
      , probabilityVectorLength = 4

      -- ADMIN
      , users = []

      --
      , inputName = ""
      , inputAuthor = ""
      , inputIdentifier = ""
      , inputDescription = ""
      , inputComments = ""
      , inputData = ""
      , inputInitialStateValue = ""
      , inputFastTickInterval = ""
      , inputStateBindings = ""
      , inputStateExpression = ""
      , inputStopExpression = ""
      , inputValuesToKeep = ""

      -- DATASETS
      , publicDataSetMetaDataList = []
      , privateDataSetMetaDataList = []

      -- NOTEBOOKS
      , kvDict = Dict.empty
      , books = []
      , currentBook = LiveBook.Book.scratchPad "anonymous"
      , cellContent = ""
      , currentCellIndex = 0
      , cloneReference = ""
      , deleteNotebookState = WaitingToDeleteNotebook
      , showNotebooks = ShowUserNotebooks
      , valueDict = Dict.empty
      , nextStateRecord = Nothing
      , state = LiveBook.State.initialState
      , svgList = []
      , valuesToKeep = 1

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
    , Cmd.batch [ setupWindow, sendToBackend GetRandomSeed, Navigation.urlAction url.path ]
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        NoOpFrontendMsg ->
            ( model, Cmd.none )

        GetRandomProbabilities k ->
            getRandomProbabilities model k

        GotRandomProbabilities listOfProbabilities ->
            ( { model | randomProbabilities = listOfProbabilities }
                |> LiveBook.State.updateWorldInModel model.tickCount listOfProbabilities
            , Cmd.none
            )

        KeyboardMsg keyMsg ->
            let
                pressedKeys =
                    Keyboard.update keyMsg model.pressedKeys

                ( newModel, cmd ) =
                    -- TODO: cmd?
                    if List.member Keyboard.Control pressedKeys && List.member Keyboard.Enter pressedKeys then
                        LiveBook.Cell.evalCell model.currentCellIndex { model | pressedKeys = pressedKeys }

                    else
                        ( { model | pressedKeys = pressedKeys }, Cmd.none )
            in
            ( newModel, cmd )

        FastTick _ ->
            case model.clockState of
                ClockRunning ->
                    --( { model | tickCount = model.tickCount + 1 }, Cmd.none )
                    let
                        f m =
                            LiveBook.Cell.evalCell m.currentCellIndex { m | tickCount = m.tickCount + 1 }

                        g m =
                            getRandomProbabilities m model.probabilityVectorLength

                        h m =
                            LiveBook.State.updateInModel m

                        clockState =
                            case getStopExpression model of
                                Nothing ->
                                    ClockRunning

                                Just stopExpression ->
                                    if stopExpression == Value.Bool True then
                                        ClockStopped

                                    else
                                        ClockRunning
                    in
                    if clockState == ClockRunning then
                        glueUpdate f g (h model)

                    else
                        ( { model | clockState = ClockStopped }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        FETick time ->
            if Predicate.canSave model && model.currentBook.dirty then
                let
                    oldBook =
                        model.currentBook

                    book =
                        { oldBook | dirty = False }
                in
                ( { model | currentTime = time, currentBook = book }, sendToBackend (SaveNotebook book) )

            else
                ( model, Cmd.none )

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

                EditDataSetPopup metaData ->
                    ( { model
                        | popupState = EditDataSetPopup metaData
                        , inputName = metaData.name
                        , inputDescription = metaData.description
                        , inputComments = metaData.comments
                      }
                    , Cmd.none
                    )

                NewNotebookPopup ->
                    if model.popupState == NewNotebookPopup then
                        ( { model | popupState = NoPopup }, Cmd.none )

                    else
                        ( { model | popupState = NewNotebookPopup }, Cmd.none )

                StateEditorPopup ->
                    if model.popupState == StateEditorPopup then
                        ( { model | popupState = NoPopup }, Cmd.none )

                    else
                        ( { model
                            | popupState = StateEditorPopup
                            , inputInitialStateValue = model.state.initialValue |> Value.toString
                            , inputStateExpression = model.state.expression
                            , inputStateBindings = model.state.bindings |> String.join "; "
                            , inputFastTickInterval = model.state.fastTickInterval |> String.fromFloat
                            , inputStopExpression = model.state.stopExpressionString
                          }
                        , Cmd.none
                        )

                ManualPopup ->
                    if model.popupState == ManualPopup then
                        ( { model | popupState = NoPopup }, Cmd.none )

                    else
                        ( { model | popupState = ManualPopup }, Cmd.none )

                ViewPublicDataSetsPopup ->
                    if model.popupState == ViewPublicDataSetsPopup then
                        ( { model | popupState = NoPopup }, Cmd.none )

                    else
                        ( { model | popupState = ViewPublicDataSetsPopup }, Cmd.none )

                ViewPrivateDataSetsPopup ->
                    if model.popupState == ViewPrivateDataSetsPopup then
                        ( { model | popupState = NoPopup }, Cmd.none )

                    else
                        ( { model | popupState = ViewPrivateDataSetsPopup }, Cmd.none )

                NewDataSetPopup ->
                    if model.popupState == NewDataSetPopup then
                        ( { model | popupState = NoPopup }, Cmd.none )

                    else
                        ( { model | popupState = NewDataSetPopup }, Cmd.none )

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

        InputIdentifier str ->
            ( { model | inputIdentifier = str }, Cmd.none )

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
                , clockState = Types.ClockStopped
              }
            , Cmd.batch
                [ Nav.pushUrl model.key "/"
                , if Predicate.canSave model then
                    let
                        oldBook =
                            model.currentBook

                        book =
                            { oldBook | dirty = False }
                    in
                    sendToBackend (SaveNotebook book)

                  else
                    Cmd.none
                ]
            )

        -- INPUT FIELDS
        InputName str ->
            ( { model | inputName = str }, Cmd.none )

        InputAuthor str ->
            ( { model | inputAuthor = str }, Cmd.none )

        InputDescription str ->
            ( { model | inputDescription = str }, Cmd.none )

        InputComments str ->
            ( { model | inputComments = str }, Cmd.none )

        InputData str ->
            ( { model | inputData = str }, Cmd.none )

        InputInitialStateValue str ->
            ( { model | inputInitialStateValue = str }, Cmd.none )

        InputFastTickInterval str ->
            ( { model | inputFastTickInterval = str }, Cmd.none )

        InputStateExpression str ->
            ( { model | inputStateExpression = str }, Cmd.none )

        InputStateBindings str ->
            ( { model | inputStateBindings = str }, Cmd.none )

        InputStopExpression str ->
            ( { model | inputStopExpression = str }, Cmd.none )

        InputValuesToKeep str ->
            ( { model | inputValuesToKeep = str }, Cmd.none )

        -- DATA
        AskToDeleteDataSet dataSetMetaData ->
            let
                publicDataSetMetaDataList =
                    List.filter (\d -> d.identifier /= dataSetMetaData.identifier) model.publicDataSetMetaDataList

                privateDataSetMetaDataList =
                    List.filter (\d -> d.identifier /= dataSetMetaData.identifier) model.privateDataSetMetaDataList
            in
            ( { model
                | popupState = NoPopup
                , publicDataSetMetaDataList = publicDataSetMetaDataList
                , privateDataSetMetaDataList = privateDataSetMetaDataList
              }
            , sendToBackend (DeleteDataSet dataSetMetaData)
            )

        AskToSaveDataSet dataSetMetaData ->
            let
                metaData : LiveBook.DataSet.DataSetMetaData
                metaData =
                    { dataSetMetaData | name = model.inputName, description = model.inputDescription, comments = model.inputComments }
            in
            ( { model
                | popupState = NoPopup
                , publicDataSetMetaDataList =
                    if metaData.public && not (List.member metaData model.publicDataSetMetaDataList) then
                        metaData :: model.publicDataSetMetaDataList

                    else if metaData.public then
                        List.Extra.setIf (\d -> d.identifier == metaData.identifier) metaData model.publicDataSetMetaDataList

                    else
                        List.filter (\d -> d.identifier /= metaData.identifier) model.publicDataSetMetaDataList
                , privateDataSetMetaDataList = List.Extra.setIf (\d -> d.identifier == metaData.identifier) metaData model.privateDataSetMetaDataList
              }
            , sendToBackend (SaveDataSet metaData)
            )

        AskToListDataSets description ->
            ( model, Lamdera.sendToBackend (GetListOfDataSets description) )

        AskToCreateDataSet ->
            case model.currentUser of
                Nothing ->
                    ( model, Cmd.none )

                Just user ->
                    let
                        newDataset =
                            LiveBook.DataSet.makeDataSet model user

                        myDataSetMeta =
                            LiveBook.DataSet.extractMetaData newDataset

                        privateDataSetMetaDataList =
                            myDataSetMeta :: model.privateDataSetMetaDataList
                    in
                    ( { model
                        | popupState = NoPopup
                        , privateDataSetMetaDataList = privateDataSetMetaDataList
                      }
                    , sendToBackend (CreateDataSet newDataset)
                    )

        -- CELLS, NOTEBOOKS
        ToggleCellLock cell ->
            ( LiveBook.Update.toggleCellLock cell model, Cmd.none )

        StringDataRequested index variable ->
            ( model
            , File.Select.file [ "text/csv" ] (StringDataSelected index variable)
            )

        StringDataSelected index variable file ->
            ( model
            , Task.perform (StringDataLoaded (File.name file) index variable) (File.toString file)
            )

        StringDataLoaded fileName index variable dataString ->
            ( LiveBook.Action.readData index fileName variable dataString model, Cmd.none )

        SetShowNotebooksState state ->
            let
                cmd =
                    case state of
                        ShowUserNotebooks ->
                            sendToBackend (GetUsersNotebooks (model.currentUser |> Maybe.map .username |> Maybe.withDefault "--@@--"))

                        ShowPublicNotebooks ->
                            sendToBackend (GetPublicNotebooks Nothing (model.currentUser |> Maybe.map .username |> Maybe.withDefault "--@@--"))
            in
            ( { model | showNotebooks = state }, cmd )

        CloneNotebook ->
            if not <| Predicate.canClone model then
                ( model, Cmd.none )

            else
                case model.currentUser of
                    Nothing ->
                        ( model, Cmd.none )

                    Just user ->
                        ( model, sendToBackend (GetClonedNotebook user.username model.currentBook.slug) )

        PullNotebook ->
            case model.currentUser of
                Nothing ->
                    ( model, Cmd.none )

                Just user ->
                    let
                        getOrigin : Book -> String
                        getOrigin book =
                            book.origin |> Maybe.withDefault "???"

                        getUsername : Maybe User.User -> String
                        getUsername user_ =
                            user_ |> Maybe.map .username |> Maybe.withDefault "???"
                    in
                    ( model
                    , sendToBackend
                        (GetPulledNotebook user.username
                            (getOrigin model.currentBook)
                            model.currentBook.slug
                            model.currentBook.id
                        )
                    )

        -- File.Download.string (String.replace "." "-" dataSet.identifier ++ ".csv") "text/csv" dataSet.data
        ExportNotebook ->
            ( model, File.Download.string (BackendHelper.compress model.currentBook.title ++ ".json") "text/json" (LiveBook.Codec.exportBook model.currentBook) )

        ImportRequested ->
            ( model, File.Select.file [ "text/json" ] ImportSelected )

        ImportSelected file ->
            ( model, Task.perform ImportLoaded (File.toString file) )

        ImportLoaded dataString ->
            let
                cmd =
                    case LiveBook.Codec.importBook dataString of
                        Err _ ->
                            Cmd.none

                        Ok newBook ->
                            case model.currentUser of
                                Nothing ->
                                    Cmd.none

                                Just user ->
                                    sendToBackend (ImportNewBook user.username newBook)
            in
            ( model, cmd )

        SetCurrentNotebook book ->
            case model.currentUser of
                Nothing ->
                    ( model, Cmd.none )

                Just user_ ->
                    let
                        previousBook =
                            model.currentBook

                        currentBook =
                            LiveBook.Book.initializeCellState book |> (\b -> { b | dirty = False })

                        books =
                            model.books
                                |> List.Extra.setIf (\b -> b.id == currentBook.id) currentBook
                                |> List.Extra.setIf (\b -> b.id == previousBook.id) previousBook

                        user =
                            { user_ | currentNotebookId = Just book.id }
                    in
                    ( { model
                        | currentUser = Just user
                        , currentBook = currentBook
                        , state = setInitialState currentBook model.state
                        , books = books
                      }
                    , Cmd.batch [ sendToBackend (UpdateUserWith user), sendToBackend (SaveNotebook previousBook) ]
                    )

        TogglePublic ->
            if not (Predicate.canSave model) then
                ( model, Cmd.none )

            else
                let
                    oldBook =
                        model.currentBook

                    newBook =
                        { oldBook | public = not oldBook.public, dirty = False }
                in
                ( { model | currentBook = newBook, books = List.Extra.setIf (\b -> b.id == newBook.id) newBook model.books }
                , sendToBackend (SaveNotebook newBook)
                )

        ClearNotebookValues ->
            LiveBook.Update.clearNotebookValues model.currentBook model

        CancelDeleteNotebook ->
            ( { model | deleteNotebookState = WaitingToDeleteNotebook }, Cmd.none )

        ProposeDeletingNotebook ->
            case model.deleteNotebookState of
                WaitingToDeleteNotebook ->
                    ( { model | deleteNotebookState = CanDeleteNotebook }, Cmd.none )

                CanDeleteNotebook ->
                    let
                        newNotebookList =
                            List.filter (\b -> b.id /= model.currentBook.id) model.books
                    in
                    case List.head newNotebookList of
                        Nothing ->
                            ( { model | message = "You can't delete your last notebook." }, Cmd.none )

                        Just book ->
                            ( { model
                                | deleteNotebookState = WaitingToDeleteNotebook
                                , currentBook = book
                                , books = newNotebookList
                              }
                            , sendToBackend (DeleteNotebook model.currentBook)
                            )

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

        Reset ->
            let
                oldState =
                    model.state

                newState =
                    { oldState | ticks = 0, values = [ oldState.initialValue ], currentValue = oldState.initialValue }
            in
            ( { model | clockState = ClockStopped, tickCount = 0, state = newState }, Cmd.none )

        SetClock state ->
            ( { model | clockState = state }, Cmd.none )

        SetState ->
            let
                valuesToKeep =
                    model.inputValuesToKeep |> String.toInt |> Maybe.withDefault 1 |> (\x -> max 1 x)

                setValue state_ =
                    case LiveBook.Parser.parse model.inputInitialStateValue of
                        Nothing ->
                            state_

                        Just value ->
                            { state_ | values = [ value ], currentValue = value, initialValue = value }

                setExpression state_ =
                    { state_ | expression = model.inputStateExpression }

                setBindings state_ =
                    { state_ | bindings = model.inputStateBindings |> String.split ";" |> List.map String.trim }

                newFastTickInterval =
                    model.inputFastTickInterval |> String.toFloat |> Maybe.withDefault 60.0 |> (\x -> max 60 x)

                setValuesToKeep : { a | valuesToKeep : Int } -> { a | valuesToKeep : Int }
                setValuesToKeep state_ =
                    { state_ | valuesToKeep = valuesToKeep }

                setFastTickInterval state_ =
                    { state_ | fastTickInterval = newFastTickInterval }

                setStopValue state_ =
                    { state_ | stopExpressionString = model.inputStopExpression }

                oldState =
                    model.state

                newState =
                    oldState
                        |> setValue
                        |> setExpression
                        |> setBindings
                        |> setFastTickInterval
                        |> setStopValue
                        |> setValuesToKeep

                oldNotebook =
                    model.currentBook

                newNotebook =
                    { oldNotebook
                        | dirty = True
                        , initialStateString = model.inputInitialStateValue
                        , stateExpression = model.inputStateExpression
                        , stateBindings = model.inputStateBindings |> String.split ";" |> List.map String.trim
                        , stopExpressionString = model.inputStopExpression
                        , fastTickInterval = newFastTickInterval
                        , valuesToKeep = valuesToKeep
                    }
            in
            ( { model
                | state = newState
                , fastTickInterval = newFastTickInterval
                , currentBook = newNotebook
                , popupState = NoPopup
                , valuesToKeep = valuesToKeep
              }
            , sendToBackend (SaveNotebook newNotebook)
            )

        UpdateNotebookTitle ->
            if not (Predicate.canSave model) then
                ( { model | message = "You can't edit this notebook." }, Cmd.none )

            else
                let
                    oldBook =
                        model.currentBook

                    compress str =
                        str |> String.toLower |> String.replace " " "-"

                    newBook =
                        { oldBook
                            | dirty = False
                            , title = model.inputTitle
                            , slug = compress (oldBook.author ++ "." ++ model.inputTitle)
                        }
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

        DeleteCell index ->
            if List.length model.currentBook.cells <= 1 then
                ( model, Cmd.none )

            else
                ( LiveBook.Update.deleteCell index model, Cmd.none )

        EditCell cell ->
            LiveBook.Update.editCell model cell

        ClearCell index ->
            LiveBook.Update.clearCell model index

        EvalCell index ->
            LiveBook.Cell.evalCell index { model | pressedKeys = [] }

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

        GotRandomSeed seed ->
            glueUpdate (\m -> ( { m | randomSeed = seed }, Cmd.none )) (\m -> getRandomProbabilities m 2) model

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
                ( { model | currentUser = Just user, message = "", clockState = ClockStopped }, Cmd.none )

            else
                ( { model | currentUser = Just user, message = "", clockState = ClockStopped }, Cmd.none )

        -- DATA
        GotListOfPublicDataSets dataSetMetaDataList ->
            ( { model | publicDataSetMetaDataList = dataSetMetaDataList }, Cmd.none )

        GotListOfPrivateDataSets dataSetMetaDataList ->
            ( { model | privateDataSetMetaDataList = dataSetMetaDataList }, Cmd.none )

        GotData index variable dataSet ->
            ( LiveBook.Action.importData index variable dataSet model
            , Cmd.none
            )

        GotDataForDownload dataSet ->
            ( model, File.Download.string (String.replace "." "-" dataSet.identifier ++ ".csv") "text/csv" dataSet.data )

        -- NOTEBOOKS
        GotNotebook book_ ->
            let
                book =
                    LiveBook.Book.initializeCellState book_

                addOrReplaceBook xbook books =
                    if List.any (\b -> b.id == xbook.id) books then
                        List.Extra.setIf (\b -> b.id == xbook.id) xbook books

                    else
                        xbook :: books
            in
            ( { model | state = setInitialState book model.state, currentBook = book, books = addOrReplaceBook book model.books }, Cmd.none )

        GotPublicNotebook book_ ->
            let
                currentUser =
                    case model.currentUser of
                        Just user ->
                            user

                        Nothing ->
                            User.guest

                book =
                    LiveBook.Book.initializeCellState book_

                addOrReplaceBook xbook books =
                    if List.any (\b -> b.id == xbook.id) books then
                        List.Extra.setIf (\b -> b.id == xbook.id) xbook books

                    else
                        xbook :: books
            in
            ( { model
                | currentUser = Just currentUser
                , showNotebooks = ShowPublicNotebooks
                , state = setInitialState book model.state
                , currentBook = book
                , books = addOrReplaceBook book model.books
              }
            , sendToBackend (GetPublicNotebooks (Just book) currentUser.username)
            )

        GotNotebooks maybeNotebook books ->
            let
                currentBook =
                    case maybeNotebook of
                        Nothing ->
                            List.head books |> Maybe.withDefault model.currentBook

                        Just book ->
                            book

                state =
                    setInitialState currentBook model.state
            in
            ( { model | books = books, currentBook = currentBook, state = state }, Cmd.none )


view : Model -> { title : String, body : List (Html.Html FrontendMsg) }
view model =
    { title = "Elm Notebook"
    , body =
        [ View.Main.view model ]
    }



--HELPERS


glueUpdate : (Model -> ( Model, Cmd FrontendMsg )) -> (Model -> ( Model, Cmd FrontendMsg )) -> Model -> ( Model, Cmd FrontendMsg )
glueUpdate f g model =
    let
        ( m1, cmd1 ) =
            f model

        ( m2, cmd2 ) =
            g m1
    in
    ( m2, Cmd.batch [ cmd1, cmd2 ] )


getRandomProbabilities : Model -> Int -> ( Model, Cmd FrontendMsg )
getRandomProbabilities model k =
    let
        ( randomProbabilities, randomSeed ) =
            Random.step (Random.list k (Random.float 0 1)) model.randomSeed
    in
    ( { model
        | randomProbabilities = randomProbabilities
        , randomSeed = randomSeed
      }
        |> LiveBook.State.updateWorldInModel model.tickCount randomProbabilities
    , Cmd.none
    )


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


setInitialState : LiveBook.Types.Book -> LiveBook.State.MState -> LiveBook.State.MState
setInitialState book state_ =
    let
        stopValues : List Value.Value
        stopValues =
            case book.stopExpressionString |> LiveBook.Parser.parse of
                Just (Value.List list) ->
                    list

                _ ->
                    []

        state1_ =
            case LiveBook.Parser.parse book.initialStateString of
                Nothing ->
                    state_

                Just value ->
                    { state_
                        | values = [ value ]
                        , currentValue = value
                        , valuesToKeep = book.valuesToKeep
                        , initialValue = value
                    }
    in
    { state1_
        | expression = book.stateExpression
        , bindings = book.stateBindings
        , stopExpressionString = book.stopExpressionString
        , fastTickInterval = book.fastTickInterval
    }


getStopExpression model =
    model.inputStopExpression
        |> LiveBook.Eval.evaluateExpressionStringWithState model.state
        |> Eval.eval
        |> Result.toMaybe
