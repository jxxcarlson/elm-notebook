module View.Geometry exposing
    ( appHeight
    , appWidth
    , bodyHeight
    , footerHeight
    , hPadding
    , headerHeight
    , mainColumnHeight
    , notebookListWidth
    , notebookWidth
    )


appWidth : { a | windowWidth : Int } -> Int
appWidth model =
    min 1300 model.windowWidth


appHeight : { a | windowHeight : number } -> number
appHeight model =
    model.windowHeight


mainColumnHeight : { a | windowHeight : number } -> number
mainColumnHeight model =
    appHeight model - headerHeight - footerHeight - 35


bodyHeight : { a | windowHeight : number } -> number
bodyHeight model =
    appHeight model - headerHeight - footerHeight


notebookWidth : { a | windowWidth : Int } -> Int
notebookWidth model =
    appWidth model - notebookListWidth


notebookListWidth =
    350


headerHeight =
    45


footerHeight =
    45


hPadding =
    18
