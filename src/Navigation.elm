module Navigation exposing (..)

import Lamdera
import Parser exposing ((|.), (|=), chompWhile, getChompedString, oneOf, succeed, symbol)
import Types exposing (FrontendModel, FrontendMsg, ToBackend(..))
import Url exposing (Url)


respondToUrlChange : FrontendModel -> Url.Url -> ( FrontendModel, Cmd FrontendMsg )
respondToUrlChange model url =
    ( { model | url = url }, Cmd.none )


urlAction : String -> Cmd FrontendMsg
urlAction path =
    if path == "/" then
        Cmd.none

    else
        let
            prefix =
                String.left 3 path

            segment =
                String.dropLeft 3 path
        in
        case prefix of
            "/p/" ->
                Lamdera.sendToBackend (Types.GetPublicNotebook segment)

            _ ->
                Cmd.none



---  URL MANAGER ---


type DocUrl
    = DocUrl String
    | NoDocUrl


handleDocId : Url -> Cmd FrontendMsg
handleDocId url =
    case parseDocUrl url of
        NoDocUrl ->
            Cmd.none

        DocUrl slug ->
            Lamdera.sendToBackend (GetPublicNotebook slug)



-- PARSE


parseDocUrl : Url -> DocUrl
parseDocUrl url =
    case Parser.run docUrlParser url.path of
        Ok docUrl ->
            docUrl

        Err _ ->
            NoDocUrl


docUrlParser : Parser.Parser DocUrl
docUrlParser =
    oneOf [ docUrlUParser_ ]


docUrlUParser_ : Parser.Parser DocUrl
docUrlUParser_ =
    succeed (\k -> DocUrl k)
        |. symbol "/"
        |= oneOf [ uuidParser ]


uuidParser : Parser.Parser String
uuidParser =
    succeed identity
        |. symbol "uuid:"
        |= parseUuid



--


parseUuid : Parser.Parser String
parseUuid =
    getChompedString <|
        chompWhile (\c -> Char.isAlphaNum c || c == '-')


parseAlphaNum : Parser.Parser String
parseAlphaNum =
    getChompedString <|
        chompWhile (\c -> Char.isAlphaNum c)
