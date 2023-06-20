module Credentials exposing (Credentials(..), Error, check, hashPw)

import Bytes exposing (Bytes, Endianness(..))
import Bytes.Encode as Encode exposing (encode, string)
import Hex.Convert as Hex
import HmacSha1
import HmacSha1.Key as Key
import PBKDF2 exposing (Error(..), pbkdf2)
import Random exposing (Generator)


type Credentials
    = V1 String String


type Error
    = GenerationError


check : String -> Credentials -> Result String ()
check password ((V1 saltStr _) as credentials) =
    let
        saltBytes =
            Hex.toBytes saltStr
                |> Maybe.withDefault (encode (string ""))
    in
    case hashPw_ saltBytes password of
        Ok incomingCreds ->
            if incomingCreds == credentials then
                Ok ()

            else
                Err "Invalid Credentials"

        Err _ ->
            Err "Invalid Credentials"


saltGenerator : Generator Bytes
saltGenerator =
    Random.list saltSize (Random.int Random.minInt Random.maxInt)
        |> Random.map
            (\saltData ->
                List.map (Encode.signedInt32 BE) saltData
                    |> Encode.sequence
                    |> encode
            )


generator : String -> Generator (Result Error Credentials)
generator password =
    saltGenerator
        |> Random.map
            (\saltBytes ->
                hashPw_ saltBytes password
                    |> Result.mapError (always GenerationError)
            )


hashPw : String -> String -> Result PBKDF2.Error Credentials
hashPw saltString password =
    case Hex.toBytes saltString of
        Nothing ->
            Err DecodingError

        Just saltBytes ->
            hashPw_ saltBytes password


hashPw_ : Bytes -> String -> Result PBKDF2.Error Credentials
hashPw_ saltBytes password =
    let
        pwBytes =
            encode <| string password
    in
    pbkdf2 ( pseudoRandomFn, psrFnOutLength )
        pwBytes
        saltBytes
        iterations
        derivedKeyLength
        |> Result.map Hex.toString
        |> Result.map (V1 (Hex.toString saltBytes))


pregen : String -> String -> Credentials
pregen salt hash =
    V1 salt hash



-- PW Hashing Parameters


iterations : Int
iterations =
    4096


derivedKeyLength : Int
derivedKeyLength =
    20


saltSize : Int
saltSize =
    ceiling (toFloat derivedKeyLength * 8 / 32)


{-| pseudorandom function output length
-}
psrFnOutLength : Int
psrFnOutLength =
    20


pseudoRandomFn : Bytes -> Bytes -> Bytes
pseudoRandomFn key message =
    HmacSha1.fromBytes (Key.fromBytes key) message
        |> HmacSha1.toBytes
