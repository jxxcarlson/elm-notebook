module View.Spinner exposing (view)

import Html exposing (Html)
import Loading
import Types exposing (FrontendModel, FrontendMsg)


view : Loading.LoadingState -> Html FrontendMsg
view loadingState =
    let
        config =
            Loading.defaultConfig
    in
    Html.div []
        [ Loading.render
            Loading.Spinner
            -- LoaderType
            { config | color = "#ff6040" }
            -- Config
            loadingState

        -- LoadingState
        ]
