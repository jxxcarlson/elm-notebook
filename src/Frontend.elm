module Frontend exposing (app)

import Authentication
import Browser exposing (UrlRequest(..))
import Browser.Dom
import Browser.Events
import Browser.Navigation as Nav
import Frontend.Authentication
import Frontend.Message
import Html exposing (Html)
import Lamdera exposing (sendToBackend)
import List.Extra
import LiveBook.Cell
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
        ]


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , url = url
      , message = "Welcome!"
      , messages = []
      , appState = Loading
      , currentTime = Time.millisToPosix 0

      -- ADMIN
      , users = []

      -- CELLS
      , cellList = [ { index = 0, text = [ "# Example: ", "1 + 1 = 2" ], value = Nothing, cellState = CSView } ]
      , cellContent = ""

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
      }
    , setupWindow
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        NoOpFrontendMsg ->
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

        SignOut ->
            ( { model
                | currentUser = Nothing
                , message = "Signed out"
                , inputUsername = ""
                , inputPassword = ""
              }
            , -- Cmd.none
              Nav.pushUrl model.key "/"
            )

        -- CELLS
        InputElmCode str ->
            ( { model | cellContent = str }, Cmd.none )

        NewCell index ->
            let
                newCell =
                    { index = index + 1
                    , text = [ "# New cell (" ++ String.fromInt (index + 2) ++ ") ", "-- code --" ]
                    , value = Nothing
                    , cellState = CSEdit
                    }

                prefix =
                    List.filter (\cell -> cell.index <= index) model.cellList
                        |> List.map (\cell -> { cell | cellState = CSView })

                suffix =
                    List.filter (\cell -> cell.index > index) model.cellList
                        |> List.map (\cell -> { cell | index = cell.index + 1 })
                        |> List.map (\cell -> { cell | cellState = CSView })
            in
            ( { model | cellList = prefix ++ (newCell :: suffix) }, Cmd.none )

        EditCell index ->
            case List.Extra.getAt index model.cellList of
                Nothing ->
                    ( model, Cmd.none )

                Just cell_ ->
                    let
                        updatedCell =
                            { cell_ | cellState = CSEdit }

                        prefix =
                            List.filter (\cell -> cell.index < index) model.cellList
                                |> List.map (\cell -> { cell | cellState = CSView })

                        suffix =
                            List.filter (\cell -> cell.index > index) model.cellList
                                |> List.map (\cell -> { cell | index = cell.index + 1 })
                                |> List.map (\cell -> { cell | cellState = CSView })
                    in
                    ( { model | cellList = prefix ++ (updatedCell :: suffix) }, Cmd.none )

        EvalCell index ->
            case List.Extra.getAt index model.cellList of
                Nothing ->
                    ( model, Cmd.none )

                Just cell_ ->
                    let
                        updatedCell =
                            LiveBook.Cell.evaluate model.cellContent cell_

                        prefix =
                            List.filter (\cell -> cell.index < index) model.cellList
                                |> List.map (\cell -> { cell | cellState = CSView })

                        suffix =
                            List.filter (\cell -> cell.index > index) model.cellList

                        --|> List.map LiveBook.Cell.evaluate
                    in
                    ( { model | cellList = prefix ++ (updatedCell :: suffix) }, Cmd.none )

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
