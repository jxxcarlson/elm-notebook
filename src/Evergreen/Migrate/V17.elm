module Evergreen.Migrate.V17 exposing (..)

{-| This migration file was automatically generated by the lamdera compiler.

It includes:

  - A migration for each of the 6 Lamdera core types that has changed
  - A function named `migrate_ModuleName_TypeName` for each changed/custom type

Expect to see:

  - `Unimplementеd` values as placeholders wherever I was unable to figure out a clear migration path for you
  - `@NOTICE` comments for things you should know about, i.e. new custom type constructors that won't get any
    value mappings from the old type by default

You can edit this file however you wish! It won't be generated again.

See <https://dashboard.lamdera.com/docs/evergreen> for more info.

-}

import Evergreen.V16.Types
import Evergreen.V17.Types
import Lamdera.Migrations exposing (..)


frontendModel : Evergreen.V16.Types.FrontendModel -> ModelMigration Evergreen.V17.Types.FrontendModel Evergreen.V17.Types.FrontendMsg
frontendModel old =
    ModelUnchanged


backendModel : Evergreen.V16.Types.BackendModel -> ModelMigration Evergreen.V17.Types.BackendModel Evergreen.V17.Types.BackendMsg
backendModel old =
    ModelUnchanged


frontendMsg : Evergreen.V16.Types.FrontendMsg -> MsgMigration Evergreen.V17.Types.FrontendMsg Evergreen.V17.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V16.Types.ToBackend -> MsgMigration Evergreen.V17.Types.ToBackend Evergreen.V17.Types.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Evergreen.V16.Types.BackendMsg -> MsgMigration Evergreen.V17.Types.BackendMsg Evergreen.V17.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V16.Types.ToFrontend -> MsgMigration Evergreen.V17.Types.ToFrontend Evergreen.V17.Types.FrontendMsg
toFrontend old =
    MsgUnchanged


migrate_Types_AppMode : Evergreen.V16.Types.AppMode -> Evergreen.V17.Types.AppMode
migrate_Types_AppMode old =
    case old of
        Evergreen.V16.Types.AMWorking ->
            Evergreen.V17.Types.AMWorking

        Evergreen.V16.Types.AMEditTitle ->
            Evergreen.V17.Types.AMEditTitle


migrate_Types_FrontendMsg : Evergreen.V16.Types.FrontendMsg -> Evergreen.V17.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V16.Types.UrlClicked p0 ->
            Evergreen.V17.Types.UrlClicked p0

        Evergreen.V16.Types.UrlChanged p0 ->
            Evergreen.V17.Types.UrlChanged p0

        Evergreen.V16.Types.NoOpFrontendMsg ->
            Evergreen.V17.Types.NoOpFrontendMsg

        Evergreen.V16.Types.FETick p0 ->
            Evergreen.V17.Types.FETick p0

        Evergreen.V16.Types.NewCell p0 ->
            Evergreen.V17.Types.NewCell p0

        Evergreen.V16.Types.EditCell p0 ->
            Evergreen.V17.Types.EditCell p0

        Evergreen.V16.Types.ClearCell p0 ->
            Evergreen.V17.Types.ClearCell p0

        Evergreen.V16.Types.EvalCell p0 ->
            Evergreen.V17.Types.EvalCell p0

        Evergreen.V16.Types.InputElmCode p0 p1 ->
            Evergreen.V17.Types.InputElmCode p0 p1

        Evergreen.V16.Types.UpdateNotebookTitle ->
            Evergreen.V17.Types.UpdateNotebookTitle

        Evergreen.V16.Types.ChangeAppMode p0 ->
            Evergreen.V17.Types.ChangeAppMode (p0 |> migrate_Types_AppMode)

        Evergreen.V16.Types.ChangePopup p0 ->
            Evergreen.V17.Types.ChangePopup (p0 |> migrate_Types_PopupState)

        Evergreen.V16.Types.GotViewport p0 ->
            Evergreen.V17.Types.GotViewport p0

        Evergreen.V16.Types.GotNewWindowDimensions p0 p1 ->
            Evergreen.V17.Types.GotNewWindowDimensions p0 p1

        Evergreen.V16.Types.SignUp ->
            Evergreen.V17.Types.SignUp

        Evergreen.V16.Types.SignIn ->
            Evergreen.V17.Types.SignIn

        Evergreen.V16.Types.SignOut ->
            Evergreen.V17.Types.SignOut

        Evergreen.V16.Types.SetSignupState p0 ->
            Evergreen.V17.Types.SetSignupState (p0 |> migrate_Types_SignupState)

        Evergreen.V16.Types.InputUsername p0 ->
            Evergreen.V17.Types.InputUsername p0

        Evergreen.V16.Types.InputSignupUsername p0 ->
            Evergreen.V17.Types.InputSignupUsername p0

        Evergreen.V16.Types.InputPassword p0 ->
            Evergreen.V17.Types.InputPassword p0

        Evergreen.V16.Types.InputPasswordAgain p0 ->
            Evergreen.V17.Types.InputPasswordAgain p0

        Evergreen.V16.Types.InputEmail p0 ->
            Evergreen.V17.Types.InputEmail p0

        Evergreen.V16.Types.InputTitle p0 ->
            Evergreen.V17.Types.InputTitle p0

        Evergreen.V16.Types.AdminRunTask ->
            Evergreen.V17.Types.AdminRunTask

        Evergreen.V16.Types.GetUsers ->
            Evergreen.V17.Types.GetUsers


migrate_Types_PopupState : Evergreen.V16.Types.PopupState -> Evergreen.V17.Types.PopupState
migrate_Types_PopupState old =
    case old of
        Evergreen.V16.Types.NoPopup ->
            Evergreen.V17.Types.NoPopup

        Evergreen.V16.Types.AdminPopup ->
            Evergreen.V17.Types.AdminPopup

        Evergreen.V16.Types.SignUpPopup ->
            Evergreen.V17.Types.SignUpPopup

        Evergreen.V16.Types.NewNotebookPopup ->
            Evergreen.V17.Types.NewNotebookPopup


migrate_Types_SignupState : Evergreen.V16.Types.SignupState -> Evergreen.V17.Types.SignupState
migrate_Types_SignupState old =
    case old of
        Evergreen.V16.Types.ShowSignUpForm ->
            Evergreen.V17.Types.ShowSignUpForm

        Evergreen.V16.Types.HideSignUpForm ->
            Evergreen.V17.Types.HideSignUpForm