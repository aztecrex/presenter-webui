module Model.State (
    initial,
    presentation,
    presentable,
    install,
    size
    ) where

import Prelude (map, ($), (+))
import Data.NonEmpty (NonEmpty, (:|))
import Data.Either (Either(..), isRight)
import Data.List (List(..), (:), length)
import Content.Slide (slides)
import Text.Markdown.SlamDown (SlamDown)
import Text.Markdown.SlamDown.Parser (parseMd)

type PresentationError = String

type Presentation = Either PresentationError {
    index :: Int,
    slides :: NonEmpty List SlamDown
}

type State = {
  presentation :: Presentation
}

initialPresentation :: Presentation
initialPresentation = Left "Initializing"

initial :: State
initial = { presentation: initialPresentation }

presentation :: State -> Presentation
presentation = _.presentation

presentable :: Presentation -> Boolean
presentable = isRight

createPresentation :: String -> Presentation
createPresentation source = case map slides $ parseMd source of
  Left _ -> Left "parse error"
  Right Nil -> Left "no content"
  Right (s : ss) -> Right { index: 10000, slides: s :| ss }

install :: String -> State -> State
install source state = state { presentation = createPresentation source}

size :: Presentation -> Int
size (Left _) = 0
size (Right { slides: (e :| es) }) = length es + 1
