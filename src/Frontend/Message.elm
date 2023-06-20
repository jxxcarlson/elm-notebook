module Frontend.Message exposing (received)

import Lamdera
import Types



--submitted : Types.FrontendModel -> ( Types.FrontendModel, Cmd Types.FrontendMsg )
--submitted model =
--    let
--        chatMessage =
--            { sender = model.currentUser |> Maybe.map .username |> Maybe.withDefault "anon"
--            , subject = ""
--            , content = model.chatMessageFieldContent
--            , date = model.currentTime
--            }
--    in
--    ( { model | chatMessageFieldContent = "", messages = model.messages }
--    , Effect.Command.batch
--        [ Effect.Lamdera.sendToBackend (Types.ChatMsgSubmitted chatMessage)
--        , View.Chat.focusMessageInput
--        , View.Chat.scrollChatToBottom
--        ]
--    )


received : Types.FrontendModel -> Types.Message -> ( Types.FrontendModel, Cmd Types.FrontendMsg )
received model message =
    let
        newMessages =
            if List.member message.status [ Types.MSRed, Types.MSYellow, Types.MSGreen ] then
                [ message ]

            else
                model.messages
    in
    if message.txt == "Sorry, password and username don't match" then
        ( { model | inputPassword = "", messages = newMessages }, Cmd.none )

    else
        ( { model | messages = newMessages }, Cmd.none )
