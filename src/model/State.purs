module Model.State (
    initial,
    presentation,
    presentable
    ) where

import Data.NonEmpty (NonEmpty)
import Data.Either (Either(..), isRight)
import Data.List (List)
import Text.Markdown.SlamDown (SlamDown)

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
