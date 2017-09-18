module Model.Presentation (
    PresentationError,
    Presentation,
    initial,
    create,
    presentable,
    size,
    slide,
    next,
    previous,
    reset
) where

import Prelude (($), map, (+), clamp, (-))
import Data.List (List(..), (:), length, (!!))
import Data.Either (Either(..), isRight)
import Data.Maybe (Maybe(..))
import Data.NonEmpty (NonEmpty, (:|))
import Text.Markdown.SlamDown (SlamDown)
import Text.Markdown.SlamDown.Parser (parseMd)
import Content.Slide (slides)

type PresentationError = String

type Presentation = Either PresentationError {
    index :: Int,
    slides :: NonEmpty List SlamDown
}

type Slide = Maybe { number :: Int, content :: SlamDown }

initial :: Presentation
initial = Left "Initializing"

size :: Presentation -> Int
size (Left _) = 0
size (Right { slides: (e :| es) }) = length es + 1

presentable :: Presentation -> Boolean
presentable = isRight

create :: String -> Presentation
create source = case map slides $ parseMd source of
  Left _ -> Left "parse error"
  Right Nil -> Left "no content"
  Right (s : ss) -> Right { index: 0, slides: s :| ss }

hydrate :: Int -> SlamDown -> { number :: Int, content :: SlamDown }
hydrate index content = { number: index + 1, content }

slide :: Presentation -> Slide
slide (Left _) = Nothing
slide (Right {index: i, slides: (c :| cs)}) = map (hydrate i) (( c : cs) !! i)

clampIndex :: Presentation -> Int -> Int
clampIndex p = clamp 0 (size p - 1)

next :: Presentation -> Presentation
next pres@(Right d) = Right (d { index = clampIndex pres (d.index + 1)})
next other = other

previous :: Presentation -> Presentation
previous pres@(Right d) = Right (d { index = clampIndex pres (d.index - 1) })
previous other = other

reset :: Presentation -> Presentation
reset pres@(Right d) = Right (d { index = 0 })
reset other = other
