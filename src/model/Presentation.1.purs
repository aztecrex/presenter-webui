module Model.Presentation.New (
    PresentationError,
    Presentation,
    Slide,
    size,
    slide,
    content,
    number,
    create
) where

import Prelude (($), map, (+), clamp, (-), (<<<), compose, class Eq, class Show, show, (==), (&&), (<>))
import Data.List (List(..), (:), length, (!!))
import Data.Either (Either(..))
import Data.Maybe (fromJust)
import Partial.Unsafe (unsafePartial)
import Data.NonEmpty (NonEmpty, (:|), fromNonEmpty)
import Optic.Core
import Text.Markdown.SlamDown (SlamDown)
import Text.Markdown.SlamDown.Parser (parseMd)
import Content.Slide (slides)

type PresentationError = String

type Content = SlamDown

type PresentationR = {
    _index :: Int,
    _content :: NonEmpty List Content
}
newtype Presentation = Pr PresentationR
newtype Slide = Sl PresentationR

rEq :: PresentationR -> PresentationR -> Boolean
rEq a b =
    a._index == b._index &&
    a._content == b._content

rShow :: PresentationR -> String
rShow {_index, _content} = "{page: " <> show (_index + 1) <> ", content: " <> show _content <> "}"

instance eqPresentation :: Eq Presentation where
  eq (Pr a) (Pr b) = rEq a b

instance showPresentation :: Show Presentation where
  show (Pr r) = rShow r

listSize :: forall a. NonEmpty List a -> Int
listSize = fromNonEmpty $ (compose length) <<< Cons

size :: Getter Presentation Int
size = to $ get'
  where get' (Pr {_content}) = listSize _content

clampIndex :: PresentationR -> Int -> Int
clampIndex {_content} = clamp 0 ((listSize _content) - 1)

slide :: Lens' Presentation Slide
slide = lens get' set'
  where get' (Pr r) = Sl r
        set' _ (Sl r) = Pr r

listAt :: forall a. NonEmpty List a -> Int -> a
listAt (c :| cs) i = unsafePartial $ fromJust $ (c : cs) !! i

content :: Getter Slide Content
content = to get'
  where get' (Sl {_index, _content}) = listAt _content _index

number :: Lens' Slide Int
number = lens get' set'
  where get' (Sl {_index}) = _index + 1
        set' (Sl r) i = Sl (r { _index = clampIndex r (i - 1) })

create :: String -> Either PresentationError Presentation
create source = case map slides $ parseMd source of
  Left _ -> Left "parse error"
  Right Nil -> Left "no content"
  Right (s : ss) -> Right $ Pr { _index: 0, _content: s :| ss }

