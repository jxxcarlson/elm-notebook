module LiveBook.Process exposing (cellContents)

import List.Extra


{-| This function takes a list of lines and returns a list of lines with with
various changes:

    - Code blocks are surrounded by ``` and ``` (markdown code block)
    - All lines in sequences of lines beginning with #, except for the last, are suffixed with " \\"

-}
cellContents cell =
    cell.text |> List.Extra.dropWhileRight (\line -> String.trim line == "") |> runMachine


runMachine : List String -> List String
runMachine input =
    loop
        { input = input
        , output = []
        , internalState = InText
        , lineCount = 0
        , linesOfCode = 0
        , numberOfLines = List.length input
        }
        nextStep
        |> List.reverse


type alias State =
    { input : List String
    , output : List String
    , internalState : InternalState
    , lineCount : Int
    , linesOfCode : Int
    , numberOfLines : Int
    }


type InternalState
    = InCode
    | InText


nextStep : State -> Step State (List String)
nextStep state =
    case List.head state.input of
        Nothing ->
            Done state.output

        Just line ->
            if state.lineCount == state.numberOfLines - 1 then
                case ( state.internalState, String.left 1 line ) of
                    ( InText, "#" ) ->
                        Done (String.dropLeft 2 line :: state.output)

                    ( InText, _ ) ->
                        Done ("```" :: "" :: line :: "```" :: state.output)

                    ( InCode, "#" ) ->
                        Done (String.dropLeft 2 line :: "" :: "```" :: state.output)

                    ( InCode, _ ) ->
                        Done ("```" :: "" :: line :: state.output)

            else
                case ( state.internalState, String.left 1 line ) of
                    ( InText, "#" ) ->
                        let
                            input =
                                List.drop 1 state.input
                        in
                        Loop
                            -- InText => InText
                            { state
                                | input = input
                                , lineCount = state.lineCount + 1
                                , output =
                                    if List.head input == Just "" then
                                        String.dropLeft 2 line :: state.output

                                    else if (List.head input |> Maybe.map (String.left 1)) == Just "#" then
                                        (String.dropLeft 2 line ++ "\\") :: state.output

                                    else
                                        String.dropLeft 2 line :: state.output
                                , internalState = InText
                            }

                    ( InText, "" ) ->
                        -- InText => InText
                        Loop
                            { state
                                | input = List.drop 1 state.input
                                , lineCount = state.lineCount + 1
                                , output =
                                    if List.Extra.getAt 1 state.input == Just "" then
                                        String.dropLeft 2 line :: state.output

                                    else
                                        String.dropLeft 2 line :: state.output
                                , internalState = InText
                            }

                    ( InText, _ ) ->
                        -- InText => InCode
                        Loop
                            { state
                                | input = List.drop 1 state.input
                                , lineCount = state.lineCount + 1
                                , output = line :: "" :: "```" :: state.output
                                , internalState = InCode
                            }

                    ( InCode, "#" ) ->
                        -- InCode => InText
                        Loop
                            { state
                                | input = List.drop 1 state.input
                                , lineCount = state.lineCount + 1
                                , output =
                                    if List.Extra.getAt 1 state.input == Just "" then
                                        String.dropLeft 2 line :: "" :: "```" :: state.output

                                    else
                                        -- (String.dropLeft 2 line ++ " \\") :: state.output
                                        line :: "" :: "```" :: state.output
                                , internalState = InText
                            }

                    ( InCode, "" ) ->
                        -- InCode => InCode
                        Loop
                            { state
                                | input = List.drop 1 state.input
                                , lineCount = state.lineCount + 1
                                , output =
                                    line :: state.output
                                , internalState = InCode
                            }

                    ( InCode, _ ) ->
                        -- InCode => InCode
                        Loop
                            { state
                                | input = List.drop 1 state.input
                                , lineCount = state.lineCount + 1
                                , output =
                                    if List.Extra.getAt 1 state.input == Just "" then
                                        line :: state.output

                                    else
                                        -- (String.dropLeft 2 line ++ " \\") :: state.output
                                        line :: state.output
                                , internalState = InCode
                            }


type Step state a
    = Loop state
    | Done a


loop : state -> (state -> Step state a) -> a
loop s nextState_ =
    case nextState_ s of
        Loop s_ ->
            loop s_ nextState_

        Done b ->
            b
