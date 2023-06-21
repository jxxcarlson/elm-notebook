module Core.Elm.JsArray exposing (appendN, empty, foldl, foldr, functions, indexedMap, initialize, initializeFromList, length, map, push, singleton, slice, unsafeGet, unsafeSet)

{-| 
@docs functions, empty, singleton, length, initialize, initializeFromList, unsafeGet, unsafeSet, push, foldl, foldr, map, indexedMap, slice, appendN
-}


import Elm.Syntax.Expression
import FastDict
import Syntax


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "empty", empty )
        , ( "singleton", singleton )
        , ( "length", length )
        , ( "initialize", initialize )
        , ( "initializeFromList", initializeFromList )
        , ( "unsafeGet", unsafeGet )
        , ( "unsafeSet", unsafeSet )
        , ( "push", push )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        , ( "map", map )
        , ( "indexedMap", indexedMap )
        , ( "slice", slice )
        , ( "appendN", appendN )
        ]


empty : Elm.Syntax.Expression.FunctionImplementation
empty =
    { name = Syntax.fakeNode "Elm.JsArray.empty"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "empty"
            )
    }


singleton : Elm.Syntax.Expression.FunctionImplementation
singleton =
    { name = Syntax.fakeNode "Elm.JsArray.singleton"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "singleton"
            )
    }


length : Elm.Syntax.Expression.FunctionImplementation
length =
    { name = Syntax.fakeNode "Elm.JsArray.length"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "length"
            )
    }


initialize : Elm.Syntax.Expression.FunctionImplementation
initialize =
    { name = Syntax.fakeNode "Elm.JsArray.initialize"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "initialize"
            )
    }


initializeFromList : Elm.Syntax.Expression.FunctionImplementation
initializeFromList =
    { name = Syntax.fakeNode "Elm.JsArray.initializeFromList"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "initializeFromList"
            )
    }


unsafeGet : Elm.Syntax.Expression.FunctionImplementation
unsafeGet =
    { name = Syntax.fakeNode "Elm.JsArray.unsafeGet"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "unsafeGet"
            )
    }


unsafeSet : Elm.Syntax.Expression.FunctionImplementation
unsafeSet =
    { name = Syntax.fakeNode "Elm.JsArray.unsafeSet"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "unsafeSet"
            )
    }


push : Elm.Syntax.Expression.FunctionImplementation
push =
    { name = Syntax.fakeNode "Elm.JsArray.push"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "push"
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = Syntax.fakeNode "Elm.JsArray.foldl"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "foldl"
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = Syntax.fakeNode "Elm.JsArray.foldr"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "foldr"
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = Syntax.fakeNode "Elm.JsArray.map"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "map"
            )
    }


indexedMap : Elm.Syntax.Expression.FunctionImplementation
indexedMap =
    { name = Syntax.fakeNode "Elm.JsArray.indexedMap"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "indexedMap"
            )
    }


slice : Elm.Syntax.Expression.FunctionImplementation
slice =
    { name = Syntax.fakeNode "Elm.JsArray.slice"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "slice"
            )
    }


appendN : Elm.Syntax.Expression.FunctionImplementation
appendN =
    { name = Syntax.fakeNode "Elm.JsArray.appendN"
    , arguments = []
    , expression =
        Syntax.fakeNode
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "appendN"
            )
    }