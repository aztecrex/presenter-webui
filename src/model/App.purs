module Model.App (
  App,
  presentationOrError,
  presentation,
  presentationError,
  create,
  _right, _left
) where

import Prelude (class Functor, class Applicative, (<<<), ($))
import Data.Either(Either(..), either)
import Data.Maybe(Maybe(..))
import Optic.Core
import Model.Presentation.New as P

type AppR = {
  _presentation :: Either P.PresentationError P.Presentation
}
newtype App = App AppR

-- _Right :: Prism (Either c a) (Either c b) a b
-- _Right = prism Right $ either (Left . Left) Right

_right :: forall l r1 r2. Prism (Either l r1) (Either l r2) r1 r2
_right = prism Right $ either (Left <<< Left) Right

-- _Left :: Prism (Either a c) (Either b c) a b
-- _Left = prism Left $ either Right (Left . Right)
_left :: forall l1 l2 r. Prism (Either l1 r) (Either l2 r) l1 l2
_left = prism Left $ either Right (Left <<< Right)

presentationOrError :: Lens' App (Either P.PresentationError P.Presentation)
presentationOrError = lens get' set'
  where get' (App {_presentation} ) = _presentation
        set' (App r) p = App (r {_presentation = p})

presentation ::
  forall p. Functor p
  => Applicative p
  => (P.Presentation -> p P.Presentation) -> App -> p App
presentation = presentationOrError .. _right

presentationError :: forall
  p. Functor p
  => Applicative p
  => (P.PresentationError -> p P.PresentationError) -> App -> p App
presentationError = presentationOrError .. _left

create :: App
create = App { _presentation: Left "uninitialized" }

-- initial :: App
-- initial = { presentation: P.initial }

-- presentation :: App -> P.Presentation
-- presentation = _.presentation

-- presentation' :: Lens' App P.Presentation
-- presentation' = lens  _.presentation  (\s p -> s { presentation = p } )

