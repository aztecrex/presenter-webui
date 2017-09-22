module Model.App
(
  App,
  presentation,
  _presentation,
  newApp
)
where

import Prelude (class Eq, class Show, map, show, (<<<), (<>), (==))
import Data.Maybe (Maybe(..), maybe)
import Data.Profunctor.Choice (class Choice)
import Data.Profunctor.Strong (class Strong)
import Data.Newtype (class Newtype, unwrap)
import Data.Symbol (SProxy(..))
import Data.Lens (Iso', Lens', _Just, iso)
import Data.Lens.Record (prop)
import Model.Presentation.New (Presentation)

type AppR = {
  _maybePresentation :: Maybe Presentation
}
newtype App = App AppR

derive instance newtypeApp :: Newtype App _

rEq :: AppR -> AppR -> Boolean
rEq a b = a._maybePresentation == b._maybePresentation

instance eqApp :: Eq App where
  eq (App a) (App b) = rEq a b

rShow :: AppR -> String
rShow rec = "{" <> maybe "" prop rec._maybePresentation<> "}"
  where prop = map ("presentation: " <> _) show

instance showApp :: Show App where
  show (App rec) = rShow rec

_record :: Iso' App AppR
_record = iso unwrap App

_pres :: forall r. Lens' { _maybePresentation :: Maybe Presentation | r } (Maybe Presentation)
_pres = prop (SProxy :: SProxy "_maybePresentation")

-- presentation :: forall p. Strong p => Choice p => p Presentation Presentation -> p App App
presentation :: Lens' App (Maybe Presentation)
presentation = _record <<< _pres

_presentation :: forall p. Strong p => Choice p => p Presentation Presentation -> p App App
_presentation = presentation <<< _Just

newApp :: App
newApp = App { _maybePresentation: Nothing }

-- _presentation :: Prism' AppR Presentation
-- _presentation = _Right

-- _presentationError :: Prism' AppR PresentationError
-- _presentationError = _Left


-- type AppR = {
--   _presentation :: Either P.PresentationError P.Presentation
-- }
-- newtype App = App AppR

-- -- _Right :: Prism (Either c a) (Either c b) a b
-- -- _Right = prism Right $ either (Left . Left) Right

-- _right :: forall l r1 r2. Prism (Either l r1) (Either l r2) r1 r2
-- _right = prism Right $ either (Left <<< Left) Right

-- -- _Left :: Prism (Either a c) (Either b c) a b
-- -- _Left = prism Left $ either Right (Left . Right)
-- _left :: forall l1 l2 r. Prism (Either l1 r) (Either l2 r) l1 l2
-- _left = prism Left $ either Right (Left <<< Right)

-- presentationOrError :: Lens' App (Either P.PresentationError P.Presentation)
-- presentationOrError = lens get' set'
--   where get' (App {_presentation} ) = _presentation
--         set' (App r) p = App (r {_presentation = p})

-- presentation ::
--   forall p. Functor p
--   => Applicative p
--   => (P.Presentation -> p P.Presentation) -> App -> p App
-- presentation = presentationOrError .. _right

-- presentationError :: forall
--   p. Functor p
--   => Applicative p
--   => (P.PresentationError -> p P.PresentationError) -> App -> p App
-- presentationError = presentationOrError .. _left

-- create :: App
-- create = App { _presentation: Left "uninitialized" }

-- -- initial :: App
-- -- initial = { presentation: P.initial }

-- -- presentation :: App -> P.Presentation
-- -- presentation = _.presentation

-- -- presentation' :: Lens' App P.Presentation
-- -- presentation' = lens  _.presentation  (\s p -> s { presentation = p } )

