module Frontend.Authentication exposing
    ( setSignupState
    , signUp
    )

import Authentication
import Config
import Lamdera
import Types exposing (FrontendModel, FrontendMsg, MessageStatus(..), ToBackend)
import Url
import User


signOut : FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
signOut model =
    let
        updateUserCmd =
            case model.currentUser of
                Nothing ->
                    Cmd.none

                Just user ->
                    Lamdera.sendToBackend (Types.UpdateUserWith user)
    in
    ( { model
        | currentUser = Nothing
        , url = Url.fromString Config.appUrl |> Maybe.withDefault model.url
        , inputUsername = ""
        , inputPassword = ""
      }
    , Cmd.batch
        [ updateUserCmd
        , Lamdera.sendToBackend (Types.SignOutBE (model.currentUser |> Maybe.map .username))
        ]
    )


signIn : FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
signIn model =
    ( { model | inputPassword = "" }, Cmd.none )


signInDev : FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
signInDev model =
    ( model, Lamdera.sendToBackend Types.SignInBEDev )


signInAsGuest : FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
signInAsGuest model =
    ( model, Lamdera.sendToBackend (Types.SignInBE "guest" (Authentication.encryptForTransit "abcd1234")) )


signUp : FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
signUp model =
    let
        errors : List String
        errors =
            []
                |> reject (String.length model.inputSignupUsername < 3) "username: at least three letters"
                |> reject (String.toLower model.inputSignupUsername /= model.inputSignupUsername) "username: all lower case characters"
                |> reject (model.inputPassword == "") "password: cannot be empty"
                |> reject (String.length model.inputPassword < 8) "password: at least 8 letters long."
                |> reject (model.inputPassword /= model.inputPasswordAgain) "passwords do not match"
                |> reject (model.inputEmail == "") "missing email address"
    in
    if List.isEmpty errors then
        ( { model | messages = [ { txt = "OK, signing you up", status = MSGreen } ] }
        , Lamdera.sendToBackend (Types.SignUpBE model.inputSignupUsername (Authentication.encryptForTransit model.inputPassword) model.inputEmail)
        )

    else
        ( { model | messages = [ { txt = String.join ", " errors, status = MSRed } ] }, Cmd.none )


reject : Bool -> String -> List String -> List String
reject condition message messages =
    if condition then
        message :: messages

    else
        messages


setSignupState : Types.FrontendModel -> Types.SignupState -> ( Types.FrontendModel, Cmd FrontendMsg )
setSignupState model signupState =
    ( { model
        | signupState = signupState
        , inputSignupUsername = ""
        , inputPassword = ""
        , inputPasswordAgain = ""
        , inputEmail = ""
        , inputRealname = ""
      }
    , Cmd.none
    )


userSignedIn model user clientId =
    ( { model
        | signupState = Types.HideSignUpForm
        , currentUser = Just user
        , inputRealname = ""
        , inputEmail = ""
        , inputUsername = ""
        , inputPassword = ""
        , inputPasswordAgain = ""
      }
    , Cmd.none
    )
