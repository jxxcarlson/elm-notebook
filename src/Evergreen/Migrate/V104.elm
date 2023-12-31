module Evergreen.Migrate.V104 exposing (..)

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

import Evergreen.V102.LiveBook.DataSet
import Evergreen.V102.LiveBook.Types
import Evergreen.V102.Types
import Evergreen.V102.User
import Evergreen.V104.LiveBook.DataSet
import Evergreen.V104.LiveBook.Types
import Evergreen.V104.Types
import Evergreen.V104.User
import Lamdera.Migrations exposing (..)
import List


frontendModel : Evergreen.V102.Types.FrontendModel -> ModelMigration Evergreen.V104.Types.FrontendModel Evergreen.V104.Types.FrontendMsg
frontendModel old =
    ModelUnchanged


backendModel : Evergreen.V102.Types.BackendModel -> ModelMigration Evergreen.V104.Types.BackendModel Evergreen.V104.Types.BackendMsg
backendModel old =
    ModelUnchanged


frontendMsg : Evergreen.V102.Types.FrontendMsg -> MsgMigration Evergreen.V104.Types.FrontendMsg Evergreen.V104.Types.FrontendMsg
frontendMsg old =
    MsgUnchanged


toBackend : Evergreen.V102.Types.ToBackend -> MsgMigration Evergreen.V104.Types.ToBackend Evergreen.V104.Types.BackendMsg
toBackend old =
    MsgMigrated ( migrate_Types_ToBackend old, Cmd.none )


backendMsg : Evergreen.V102.Types.BackendMsg -> MsgMigration Evergreen.V104.Types.BackendMsg Evergreen.V104.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V102.Types.ToFrontend -> MsgMigration Evergreen.V104.Types.ToFrontend Evergreen.V104.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_LiveBook_DataSet_DataSet : Evergreen.V102.LiveBook.DataSet.DataSet -> Evergreen.V104.LiveBook.DataSet.DataSet
migrate_LiveBook_DataSet_DataSet old =
    old


migrate_LiveBook_DataSet_DataSetMetaData : Evergreen.V102.LiveBook.DataSet.DataSetMetaData -> Evergreen.V104.LiveBook.DataSet.DataSetMetaData
migrate_LiveBook_DataSet_DataSetMetaData old =
    old


migrate_LiveBook_Types_Book : Evergreen.V102.LiveBook.Types.Book -> Evergreen.V104.LiveBook.Types.Book
migrate_LiveBook_Types_Book old =
    { id = old.id
    , dirty = old.dirty
    , slug = old.slug
    , origin = old.origin
    , author = old.author
    , createdAt = old.createdAt
    , updatedAt = old.updatedAt
    , public = old.public
    , title = old.title
    , cells = old.cells |> List.map migrate_LiveBook_Types_Cell
    , currentIndex = old.currentIndex
    , initialStateString = old.initialStateString
    , stateExpression = old.stateExpression
    , stateBindings = old.stateBindings
    , fastTickInterval = old.fastTickInterval
    , stopExpressionString = old.stopExpressionString
    }


migrate_LiveBook_Types_Cell : Evergreen.V102.LiveBook.Types.Cell -> Evergreen.V104.LiveBook.Types.Cell
migrate_LiveBook_Types_Cell old =
    { index = old.index
    , text = old.text
    , bindings = old.bindings
    , expression = old.expression
    , value = old.value |> migrate_LiveBook_Types_CellValue
    , cellState = old.cellState |> migrate_LiveBook_Types_CellState
    , locked = old.locked
    }


migrate_LiveBook_Types_CellState : Evergreen.V102.LiveBook.Types.CellState -> Evergreen.V104.LiveBook.Types.CellState
migrate_LiveBook_Types_CellState old =
    case old of
        Evergreen.V102.LiveBook.Types.CSEdit ->
            Evergreen.V104.LiveBook.Types.CSEdit

        Evergreen.V102.LiveBook.Types.CSView ->
            Evergreen.V104.LiveBook.Types.CSView


migrate_LiveBook_Types_CellValue : Evergreen.V102.LiveBook.Types.CellValue -> Evergreen.V104.LiveBook.Types.CellValue
migrate_LiveBook_Types_CellValue old =
    case old of
        Evergreen.V102.LiveBook.Types.CVNone ->
            Evergreen.V104.LiveBook.Types.CVNone

        Evergreen.V102.LiveBook.Types.CVString p0 ->
            Evergreen.V104.LiveBook.Types.CVString p0

        Evergreen.V102.LiveBook.Types.CVVisual p0 p1 ->
            Evergreen.V104.LiveBook.Types.CVVisual (p0 |> migrate_LiveBook_Types_VisualType) p1

        Evergreen.V102.LiveBook.Types.CVPlot2D p0 p1 ->
            Evergreen.V104.LiveBook.Types.CVPlot2D p0 p1


migrate_LiveBook_Types_VisualType : Evergreen.V102.LiveBook.Types.VisualType -> Evergreen.V104.LiveBook.Types.VisualType
migrate_LiveBook_Types_VisualType old =
    case old of
        Evergreen.V102.LiveBook.Types.VTChart ->
            Evergreen.V104.LiveBook.Types.VTChart

        Evergreen.V102.LiveBook.Types.VTSvg ->
            Evergreen.V104.LiveBook.Types.VTSvg

        Evergreen.V102.LiveBook.Types.VTImage ->
            Evergreen.V104.LiveBook.Types.VTImage


migrate_Types_DataSetDescription : Evergreen.V102.Types.DataSetDescription -> Evergreen.V104.Types.DataSetDescription
migrate_Types_DataSetDescription old =
    case old of
        Evergreen.V102.Types.PublicDatasets ->
            Evergreen.V104.Types.PublicDatasets

        Evergreen.V102.Types.UserDatasets p0 ->
            Evergreen.V104.Types.UserDatasets p0


migrate_Types_Message : Evergreen.V102.Types.Message -> Evergreen.V104.Types.Message
migrate_Types_Message old =
    { txt = old.txt
    , status = old.status |> migrate_Types_MessageStatus
    }


migrate_Types_MessageStatus : Evergreen.V102.Types.MessageStatus -> Evergreen.V104.Types.MessageStatus
migrate_Types_MessageStatus old =
    case old of
        Evergreen.V102.Types.MSWhite ->
            Evergreen.V104.Types.MSWhite

        Evergreen.V102.Types.MSYellow ->
            Evergreen.V104.Types.MSYellow

        Evergreen.V102.Types.MSGreen ->
            Evergreen.V104.Types.MSGreen

        Evergreen.V102.Types.MSRed ->
            Evergreen.V104.Types.MSRed


migrate_Types_ToBackend : Evergreen.V102.Types.ToBackend -> Evergreen.V104.Types.ToBackend
migrate_Types_ToBackend old =
    case old of
        Evergreen.V102.Types.NoOpToBackend ->
            Evergreen.V104.Types.NoOpToBackend

        Evergreen.V102.Types.GetRandomSeed ->
            Evergreen.V104.Types.GetRandomSeed

        Evergreen.V102.Types.RunTask ->
            Evergreen.V104.Types.RunTask

        Evergreen.V102.Types.SendUsers ->
            Evergreen.V104.Types.SendUsers

        Evergreen.V102.Types.DeleteDataSet p0 ->
            Evergreen.V104.Types.DeleteDataSet (p0 |> migrate_LiveBook_DataSet_DataSetMetaData)

        Evergreen.V102.Types.SaveDataSet p0 ->
            Evergreen.V104.Types.SaveDataSet (p0 |> migrate_LiveBook_DataSet_DataSetMetaData)

        Evergreen.V102.Types.GetListOfDataSets p0 ->
            Evergreen.V104.Types.GetListOfDataSets (p0 |> migrate_Types_DataSetDescription)

        Evergreen.V102.Types.CreateDataSet p0 ->
            Evergreen.V104.Types.CreateDataSet (p0 |> migrate_LiveBook_DataSet_DataSet)

        Evergreen.V102.Types.GetData p0 p1 p2 ->
            Evergreen.V104.Types.GetData p0 p1 p2

        Evergreen.V102.Types.GetDataSetForDownload p0 ->
            Evergreen.V104.Types.GetDataSetForDownload p0

        Evergreen.V102.Types.CreateNotebook p0 p1 ->
            Evergreen.V104.Types.CreateNotebook p0 p1

        Evergreen.V102.Types.ImportNewBook p0 p1 ->
            Evergreen.V104.Types.ImportNewBook p0 (p1 |> migrate_LiveBook_Types_Book)

        Evergreen.V102.Types.SaveNotebook p0 ->
            Evergreen.V104.Types.SaveNotebook (p0 |> migrate_LiveBook_Types_Book)

        Evergreen.V102.Types.DeleteNotebook p0 ->
            Evergreen.V104.Types.DeleteNotebook (p0 |> migrate_LiveBook_Types_Book)

        Evergreen.V102.Types.GetPublicNotebook p0 ->
            Evergreen.V104.Types.GetPublicNotebook p0

        Evergreen.V102.Types.GetClonedNotebook p0 p1 ->
            Evergreen.V104.Types.GetClonedNotebook p0 p1

        Evergreen.V102.Types.GetPulledNotebook p0 p1 p2 p3 ->
            Evergreen.V104.Types.GetPulledNotebook p0 p1 p2 p3

        Evergreen.V102.Types.UpdateSlugDict p0 ->
            Evergreen.V104.Types.UpdateSlugDict (p0 |> migrate_LiveBook_Types_Book)

        Evergreen.V102.Types.GetUsersNotebooks p0 ->
            Evergreen.V104.Types.GetUsersNotebooks p0

        Evergreen.V102.Types.GetPublicNotebooks p0 ->
            Evergreen.V104.Types.GetPublicNotebooks Nothing p0

        Evergreen.V102.Types.SignUpBE p0 p1 p2 ->
            Evergreen.V104.Types.SignUpBE p0 p1 p2

        Evergreen.V102.Types.SignInBEDev ->
            Evergreen.V104.Types.SignInBEDev

        Evergreen.V102.Types.SignInBE p0 p1 ->
            Evergreen.V104.Types.SignInBE p0 p1

        Evergreen.V102.Types.SignOutBE p0 ->
            Evergreen.V104.Types.SignOutBE p0

        Evergreen.V102.Types.UpdateUserWith p0 ->
            Evergreen.V104.Types.UpdateUserWith (p0 |> migrate_User_User)


migrate_Types_ToFrontend : Evergreen.V102.Types.ToFrontend -> Evergreen.V104.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V102.Types.NoOpToFrontend ->
            Evergreen.V104.Types.NoOpToFrontend

        Evergreen.V102.Types.MessageReceived p0 ->
            Evergreen.V104.Types.MessageReceived (p0 |> migrate_Types_Message)

        Evergreen.V102.Types.GotRandomSeed p0 ->
            Evergreen.V104.Types.GotRandomSeed p0

        Evergreen.V102.Types.GotUsers p0 ->
            Evergreen.V104.Types.GotUsers p0

        Evergreen.V102.Types.GotListOfPublicDataSets p0 ->
            Evergreen.V104.Types.GotListOfPublicDataSets p0

        Evergreen.V102.Types.GotListOfPrivateDataSets p0 ->
            Evergreen.V104.Types.GotListOfPrivateDataSets p0

        Evergreen.V102.Types.GotData p0 p1 p2 ->
            Evergreen.V104.Types.GotData p0 p1 (p2 |> migrate_LiveBook_DataSet_DataSet)

        Evergreen.V102.Types.GotDataForDownload p0 ->
            Evergreen.V104.Types.GotDataForDownload (p0 |> migrate_LiveBook_DataSet_DataSet)

        Evergreen.V102.Types.GotNotebook p0 ->
            Evergreen.V104.Types.GotNotebook (p0 |> migrate_LiveBook_Types_Book)

        Evergreen.V102.Types.GotPublicNotebook p0 ->
            Evergreen.V104.Types.GotPublicNotebook (p0 |> migrate_LiveBook_Types_Book)

        Evergreen.V102.Types.GotNotebooks p0 ->
            Evergreen.V104.Types.GotNotebooks Nothing []

        Evergreen.V102.Types.SendMessage p0 ->
            Evergreen.V104.Types.SendMessage p0

        Evergreen.V102.Types.UserSignedIn p0 p1 ->
            Evergreen.V104.Types.UserSignedIn (p0 |> migrate_User_User) p1

        Evergreen.V102.Types.SendUser p0 ->
            Evergreen.V104.Types.SendUser (p0 |> migrate_User_User)


migrate_User_User : Evergreen.V102.User.User -> Evergreen.V104.User.User
migrate_User_User old =
    old
