module Model.App.New where

import Prelude (class Functor, class Applicative)
import Data.Either(Either(..))
import Data.Maybe(Maybe(..))
import Optic.Core
import Model.Presentation.New as P

type AppR = {
  _presentation :: Either P.PresentationError P.Presentation
}
newtype App = App AppR

-- prism :: forall f p s t a b. Applicative f => Choice p =>
--   (b -> t) -> (s -> Either t a) -> p a (f b) -> p s (f t)

-- prism' :: forall s a b.
--   (b -> s) -> (s -> Maybe a) -> Prism s s a b

_right :: forall l r. Prism' (Either l r) r
_right = prism' bs' sMa'
  where bs' = Right
        sMa' (Right a) = Just a
        sMa' (Left _) = Nothing

_left :: forall l r. Prism' (Either l r) l
_left = prism' bs' sMa'
  where bs' = Left
        sMa' (Left a) = Just a
        sMa' (Right _) = Nothing

presentation' :: Lens' App (Either P.PresentationError P.Presentation)
presentation' = lens get' set'
  where get' (App {_presentation} ) = _presentation
        set' (App r) p = App (r {_presentation = p})

-- presentation :: forall p.
--   Functor p
--   => Applicative p
--   => (String -> p String) -> App -> p App
presentation ::
  forall p. Functor p
  => Applicative p
  => (P.Presentation -> p P.Presentation) -> App -> p App
presentation = presentation' .. _right

presentationError :: forall
  p. Functor p
  => Applicative p
  => (P.PresentationError -> p P.PresentationError) -> App -> p App
presentationError = presentation' .. _left




-- initial :: App
-- initial = { presentation: P.initial }

-- presentation :: App -> P.Presentation
-- presentation = _.presentation

-- presentation' :: Lens' App P.Presentation
-- presentation' = lens  _.presentation  (\s p -> s { presentation = p } )

