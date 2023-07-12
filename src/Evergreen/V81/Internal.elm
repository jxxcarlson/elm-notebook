module Evergreen.V81.Internal exposing (..)


type NColor
    = Red
    | Black


type InnerDict k v
    = InnerNode NColor k v (InnerDict k v) (InnerDict k v)
    | Leaf


type InternalDict k v
    = Dict Int (InnerDict k v)
