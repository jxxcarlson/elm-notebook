module Predicate exposing (canClone, canSave)

import Types


canSave : Types.FrontendModel -> Bool
canSave model =
    (model.currentUser |> Maybe.map .username) == Just model.currentBook.author


canClone : Types.FrontendModel -> Bool
canClone model =
    case model.currentUser of
        Just user ->
            model.currentBook.author
                /= user.username
                && (not <| String.contains user.username (Maybe.withDefault "---" model.currentBook.origin))

        Nothing ->
            False
