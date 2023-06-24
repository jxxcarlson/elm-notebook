module Predicate exposing (canSave)

import Types


canSave : Types.FrontendModel -> Bool
canSave model =
    (model.currentUser |> Maybe.map .username) == Just model.currentBook.author
