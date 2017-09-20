module Model.Presentation.New (
    PresentationError,
    Presentation
) where

import Prelude (($), map, (+), clamp, (-), const, id, (<<<), compose)
import Data.List (List(..), (:), length, (!!))
import Data.Either (Either(..), isRight, either)
import Data.Maybe (Maybe(..), fromJust)
import Partial.Unsafe (unsafePartial)
import Data.NonEmpty (NonEmpty, (:|), fromNonEmpty)
import Optic.Core
import Text.Markdown.SlamDown (SlamDown)
import Text.Markdown.SlamDown.Parser (parseMd)
-- import Content.Slide (slides)

type PresentationError = String

type Content = SlamDown

type PresentationR = {
    index :: Int,
    content :: NonEmpty List SlamDown
}
newtype Presentation = Pr PresentationR

runPresentation :: Presentation -> PresentationR
runPresentation (Pr d) = d

listSize :: forall a. NonEmpty List a -> Int
listSize = fromNonEmpty $ (compose length) <<< Cons

size :: Getter Presentation Int
size = to $ listSize <<< _.content <<< runPresentation

clampIndex :: Presentation -> Int -> Int
clampIndex p = clamp 0 ((p ^. size) - 1)

-- slide :: Lens Presentation Presentation Slide Int
-- slide = lens get' set'
--   where get' (Pr {index: i, content: (c :| cs)}) = Sl {
--                 index: i,
--                 content: unsafePartial $ fromJust $ (c : cs) !! i
--             }
--         set' pr @(Pr p) i = Pr (p { index = clampIndex pr i })

listAt :: forall a. NonEmpty List a -> Int -> a
listAt (c :| cs) i = unsafePartial $ fromJust $ (c : cs) !! i

content :: Getter Presentation Content
content = to get'
  where get' (Pr {index, content}) = listAt content index

-- size :: _
-- size = nonEmptyListSize <<< slides

-- presentationSize :: Presentation -> Int
-- presentationSize = neSize <<< _.slides <<< runPresentation




-- create :: String -> Either PresentationError Presentation
-- create source = case map slides $ parseMd source of
--   Left _ -> Left "parse error"
--   Right Nil -> Left "no content"
--   Right (s : ss) -> Right { index: 0, slides: s :| ss }

-- hydrate :: Int -> SlamDown -> { number :: Int, content :: SlamDown }
-- hydrate index content = { number: index + 1, content }

-- slide :: Presentation -> Slide
-- slide (Left _) = Nothing
-- slide (Right {index: i, slides: (c :| cs)}) = map (hydrate i) (( c : cs) !! i)

-- clampIndex :: Presentation -> Int -> Int
-- clampIndex p = clamp 0 (size p - 1)

-- next :: Presentation -> Presentation
-- next pres@(Right d) = Right (d { index = clampIndex pres (d.index + 1)})
-- next other = other

-- previous :: Presentation -> Presentation
-- previous pres@(Right d) = Right (d { index = clampIndex pres (d.index - 1) })
-- previous other = other

-- reset :: Presentation -> Presentation
-- reset pres@(Right d) = Right (d { index = 0 })
-- reset other = other
