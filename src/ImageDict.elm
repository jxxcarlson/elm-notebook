module ImageDict exposing
    ( ImageError(..)
    , SmallImageRecord
    )

import Dict
import List.Extra
import Types


type alias SmallImageRecord =
    { url : String, filename : String }


type ImageError
    = ImageOwnerNotFound String
    | ImageRecordNotFound String


substituteFilenameForUrls : List SmallImageRecord -> String -> String
substituteFilenameForUrls imageRecords str =
    let
        folder : SmallImageRecord -> String -> String
        folder { url, filename } str_ =
            -- TODO: The below (the second 'String.replace' is a terrible hack
            -- TODO: Should be resolved at the level of the compiler
            String.replace (String.replace "https://" "" url) filename str_
                |> String.replace ("https://" ++ filename) filename

        output =
            List.foldl folder str imageRecords
    in
    output


urlsToSmallImageRecords : Types.ImageDict -> List String -> List SmallImageRecord
urlsToSmallImageRecords imageDict urls =
    let
        smallDict =
            cloudFlareUrlToFilenameDictFromUrlList "cf" urls imageDict

        mapper : Int -> String -> SmallImageRecord
        mapper k url =
            if String.startsWith "https://imagedelivery.net" url then
                case Dict.get url smallDict of
                    Nothing ->
                        { url = url, filename = "cf-image-" ++ String.fromInt k ++ ".jpg" }

                    Just filename_ ->
                        { url = url, filename = filename_ }

            else
                { url = url, filename = "image-" ++ String.fromInt k ++ ".jpg" }
    in
    List.indexedMap (\k url -> mapper k url) urls


{-|

    Given a list of Cloudflare urls, a prefix:String, and an imageDict,
    compute dictionary mapping urls to filenames. The filenames
    will of the form IDENTIFIER.avi, since Cloudflare image urls
    refer to .avi files.

    Example.

    With urlList =
              [ "https://yada.io/"
              , "https://cdn.download.ams.birds.cornell.edu/api/v1/asset/325521391/1800"
              , "https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/d62e1103-57e1-4413-4b2d-49558d754e00/public"
              ]
    prefix = "foo"

    and using the result of `Dict.get "jxxcarlson" model.imageUserDict` for usersImageDict, we obtain this:

    [("https://cdn.download.ams.birds.cornell.edu/api/v1/asset/325521391/1800","foo-2.avi")
    ,("https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/d62e1103-57e1-4413-4b2d-49558d754e00/public","jxxcarlson-gnatcatcher.jpg")
    ,("https://yada.io/","foo-1.avi")]

-}
cloudFlareUrlToFilenameDictFromUrlList : String -> List String -> Types.ImageDict -> Dict.Dict String String
cloudFlareUrlToFilenameDictFromUrlList prefix urlList usersImageDict =
    let
        folder : String -> ( Int, Dict.Dict String String ) -> ( Int, Dict.Dict String String )
        folder url ( index, dict ) =
            case Dict.get url (usersImageDict |> makeReverseDict) of
                Nothing ->
                    ( index + 1, Dict.insert url (prefix ++ "-" ++ String.fromInt index ++ ".jpg") dict )

                Just identifier ->
                    case getFilename identifier of
                        Nothing ->
                            ( index + 1, Dict.insert url (prefix ++ "-" ++ String.fromInt index ++ ".jpg") dict )

                        Just filename_ ->
                            ( index, Dict.insert url filename_ dict )
    in
    List.foldl folder ( 1, Dict.empty ) urlList |> Tuple.second


makeUrlToFilenameDict : Types.Username -> Types.ImageUserDict -> Maybe (Dict.Dict String String)
makeUrlToFilenameDict username_ dict =
    Maybe.map makeReverseDict (Dict.get username_ dict)


makeReverseDict : Dict.Dict String Types.ImageRecord -> Dict.Dict String String
makeReverseDict dict =
    dict
        |> Dict.toList
        |> List.map (\( key, record ) -> ( record.urlList |> List.head |> Maybe.withDefault "nothing", key ))
        |> List.filter (\( key, _ ) -> key /= "nothing")
        |> Dict.fromList


remove : Types.Username -> String -> Types.ImageUserDict -> Types.ImageUserDict
remove username_ identifier imageUserDict =
    case Dict.get username_ imageUserDict of
        Nothing ->
            imageUserDict

        Just imageDict ->
            Dict.insert username_ (Dict.remove identifier imageDict) imageUserDict


lookup : Types.Username -> String -> Types.ImageUserDict -> Result ImageError Types.ImageRecord
lookup username_ identifier imageUserDict =
    case Dict.get username_ imageUserDict of
        Nothing ->
            Err (ImageOwnerNotFound username_)

        Just imageDict ->
            case Dict.get identifier imageDict of
                Nothing ->
                    Err (ImageRecordNotFound identifier)

                Just record ->
                    Ok record



--find : Types.Username -> String -> Types.ImageUserDict -> Maybe Types.ImageRecord


all : Types.Username -> Types.ImageUserDict -> List Types.ImageRecord
all username_ dict =
    case Dict.get username_ dict of
        Nothing ->
            []

        Just imageDict ->
            Dict.values imageDict


insert : Types.Username -> String -> Types.ImageRecord -> Types.ImageUserDict -> Types.ImageUserDict
insert username_ identifier imageRecord imageUserDict =
    case Dict.get username_ imageUserDict of
        Nothing ->
            imageUserDict

        Just imageDict ->
            Dict.insert username_ (Dict.insert identifier imageRecord imageDict) imageUserDict


publicDict : Types.ImageUserDict -> Types.ImageDict
publicDict dictV2 =
    let
        folder3 : Types.ImageRecord -> Types.ImageDict -> Types.ImageDict
        folder3 record dict_ =
            if record.public then
                Dict.insert record.identifier record dict_

            else
                dict_

        records : List Types.ImageRecord
        records =
            Dict.values dictV2
                |> List.map (\dict_ -> Dict.values dict_)
                |> List.concat
    in
    List.foldl folder3 Dict.empty records


updatePublicRecords : Types.ImageUserDict -> Types.ImageUserDict
updatePublicRecords dict =
    Dict.insert "public" (publicDict dict) dict


dictToV2 : Types.ImageDict -> Types.ImageUserDict
dictToV2 dictV1 =
    let
        records : List ( String, Types.ImageRecord )
        records =
            Dict.toList dictV1

        usernames =
            "public" :: (List.map Tuple.first records |> List.Extra.unique)

        initialDictV2 =
            List.foldl folder1 Dict.empty usernames

        folder1 : String -> Types.ImageUserDict -> Types.ImageUserDict
        folder1 username_ dict =
            Dict.insert username_ Dict.empty dict

        folder2 : ( String, Types.ImageRecord ) -> Types.ImageUserDict -> Types.ImageUserDict
        folder2 ( identifier, record ) dictV2 =
            case Dict.get identifier dictV2 of
                Nothing ->
                    dictV2

                Just dictV1_ ->
                    case username identifier of
                        Nothing ->
                            dictV2

                        Just username_ ->
                            Dict.insert username_ (Dict.insert identifier record dictV1_) dictV2
    in
    List.foldl folder2 initialDictV2 records


username : String -> Maybe String
username str =
    String.split "/" str |> List.head


getFilename : String -> Maybe String
getFilename str =
    String.split ":" str |> List.head
