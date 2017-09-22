module Model.App
(
  App,
  PresentationError,
  presentation,
  presentationError,
  newApp
)
where

import Prelude (class Functor, class Applicative, const, id, (<<<), (<>), ($), class Eq, class Show, (==), eq, show)
import Data.Either (Either(..), either)
import Data.Maybe (Maybe(..))
import Data.Profunctor (class Profunctor)
import Data.Profunctor.Choice (class Choice)
import Data.Profunctor.Strong (class Strong)
import Data.Newtype (class Newtype, unwrap)
import Data.Symbol (SProxy(..))
import Data.Lens
import Data.Lens.Record (prop)
import Model.Presentation.New

type PresentationError = String

type PresOrError = Either PresentationError Presentation

type AppR = {
  _presentation :: PresOrError
}
newtype App = App AppR

derive instance newtypeApp :: Newtype App _

rEq :: AppR -> AppR -> Boolean
rEq a b = a._presentation == b._presentation

instance eqApp :: Eq App where
  eq (App a) (App b) = rEq a b

rShow :: AppR -> String
rShow rec = "{presentation: " <> either ("ERR " <> _) show rec._presentation <> "}"

instance showApp :: Show App where
  show (App rec) = rShow rec

_record :: Iso' App AppR
_record = iso unwrap App

_presOrError :: forall r. Lens' { _presentation :: PresOrError | r } PresOrError
_presOrError = prop (SProxy :: SProxy "_presentation")

_pres :: Lens PresOrError PresOrError (Maybe Presentation) String
_pres = lens get' set'
  where get' = either (const Nothing) Just
        set' _ = create

presentation :: Lens App App (Maybe Presentation) String
presentation = _record <<< _presOrError <<< _pres

presentationError :: forall p. Strong p => Choice p => Optic' p App String
presentationError = _record <<< _presOrError <<< _Left

newApp :: App
newApp = App { _presentation: Left "uninitialized" }

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

