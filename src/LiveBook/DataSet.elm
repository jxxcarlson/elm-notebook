module LiveBook.DataSet exposing
    ( DataSet
    , DataSetMetaData
    , extractMetaData
    , makeDataSet
    )

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


type alias DataSetMetaData =
    { author : String
    , name : String
    , identifier : String
    , public : Bool
    , createdAt : Time.Posix
    , modifiedAt : Time.Posix
    , description : String
    , comments : String
    }


extractMetaData : DataSet -> DataSetMetaData
extractMetaData dataSet =
    { author = dataSet.author
    , name = dataSet.name
    , identifier = dataSet.identifier
    , public = dataSet.public
    , createdAt = dataSet.createdAt
    , modifiedAt = dataSet.modifiedAt
    , description = dataSet.description
    , comments = dataSet.comments
    }


makeDataSet :
    { a
        | inputName : String
        , inputAuthor : String
        , inputDescription : String
        , inputComments : String
        , inputData : String
        , inputIdentifier : String
    }
    -> User
    -> DataSet
makeDataSet model user =
    { author = user.username
    , name = model.inputName
    , identifier = LiveBook.Utility.slugify user.username ++ "." ++ LiveBook.Utility.slugify model.inputIdentifier
    , public = False
    , createdAt = Time.millisToPosix 0
    , modifiedAt = Time.millisToPosix 0
    , description = model.inputDescription
    , comments = model.inputComments
    , data = model.inputData
    }
