module UILibrary.Input exposing (largePrimary, smallPrimary, LabelStyle(..))

import Element 
import Element.Input
import Element.Font
import UILibrary.Color

type alias Params msg =
    { msg : String -> msg
    , label : String
    , placement: LabelStyle
    , placeholder : Maybe String
    }


type LabelStyle = 
   NoLabel
   | LabelAbove Element.Color
   | LabelLeft Element.Color


makePlaceholder : Maybe String -> Maybe (Element.Input.Placeholder msg)
makePlaceholder maybeStr = 
  case maybeStr of 
     Nothing -> Nothing
     Just str -> Just (Element.Input.placeholder [] (Element.text str))

makeLabel : LabelStyle -> Int -> String -> Element.Input.Label msg
makeLabel style size labelText = 
   case style  of 
     NoLabel -> Element.Input.labelHidden  labelText
     LabelAbove color -> Element.Input.labelAbove [Element.Font.color color] <| Element.el [Element.Font.size size] (Element.text labelText)
     LabelLeft color -> Element.Input.labelLeft [Element.Font.color color] <| Element.el [Element.Font.size size] (Element.text labelText)

type Option
    = FontItalic
    | FontUnderline


largePrimary : Params msg -> String -> Element.Element msg
largePrimary params inputString =
       Element.Input.text [  Element.Font.size 16, Element.Font.color UILibrary.Color.darkGray]
        { onChange = params.msg
        , text = inputString
        , placeholder = makePlaceholder params.placeholder
        , label = makeLabel params.placement 16 params.label
        }


smallPrimary : Params msg -> String -> Element.Element msg
smallPrimary params inputString =
       Element.Input.text [  Element.Font.size 12, Element.Font.color UILibrary.Color.darkGray]
        { onChange = params.msg
        , text = inputString
        , placeholder = makePlaceholder params.placeholder
        , label = makeLabel params.placement 12 params.label
        }


