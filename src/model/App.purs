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

presentation :: Lens' App (Maybe Presentation)
presentation = _record <<< _pres

_presentation :: forall p. Strong p => Choice p => p Presentation Presentation -> p App App
_presentation = presentation <<< _Just

newApp :: App
newApp = App { _maybePresentation: Nothing }

