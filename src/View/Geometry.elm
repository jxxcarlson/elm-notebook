module View.Geometry exposing
    ( appHeight
    , appWidth
    , footerHeight
    , hPadding
    , mainColumnHeight
    )


appWidth : { a | windowWidth : Int } -> Int
appWidth model =
    min 900 model.windowWidth


appHeight : { a | windowHeight : number } -> number
appHeight model =
    model.windowHeight


mainColumnHeight : { a | windowHeight : number } -> number
mainColumnHeight model =
    appHeight model - headerHeight - footerHeight - 15


headerHeight =
    30


footerHeight =
    30


hPadding =
    18
