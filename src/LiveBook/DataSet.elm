module LiveBook.DataSet exposing (DataSet, makeDataSet)

import LiveBook.Utility
import Time
import User exposing (User)


type alias DataSet =
    { author : String
    , name : String
    , identifier : String
    , public : Bool
    , createdAt : Time.Posix
    , modifiedAt : Time.Posix
    , description : String
    , comments : String
    , data : String
    }


makeDataSet :
    { a
        | inputName : String
        , inputAuthor : String
        , inputDescription : String
        , inputComments : String
        , inputData : String
    }
    -> User
    -> DataSet
makeDataSet model user =
    { author = user.username
    , name = model.inputName
    , identifier = LiveBook.Utility.slugify model.inputAuthor ++ "." ++ LiveBook.Utility.slugify model.inputName
    , public = False
    , createdAt = Time.millisToPosix 0
    , modifiedAt = Time.millisToPosix 0
    , description = model.inputDescription
    , comments = model.inputComments
    , data = model.inputData
    }
