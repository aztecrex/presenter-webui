module UI.View (view) where

import Prelude (const, discard, show, ($), (<>))
import Data.Maybe (maybe)
import Text.Smolder.Markup (text, (#!), (!))
import Text.Smolder.HTML (div, p, button, h3, a, span)
import Text.Smolder.HTML.Attributes (href, className, style)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Data.Lens ((^.))
import Model.State (State, presentation)
import Model.Presentation (Presentation, content, number, size)
import Content.Render(render)
import UI.Event(Event(..))

noslide :: HTML Event
noslide = do
    div ! className "navbar navbar-inverse" $ do
      div ! className "container" $ do
        a ! className "navbar-brand" ! href "/" $ text "Presentation"
    div ! className "container" $ do
      p $ text "Connecting....."



slide :: Presentation -> HTML Event
slide pres = do
    div ! className "navbar navbar-inverse" $ do
      div ! className "container" $ do
        a ! className "navbar-brand" ! href "/" $ text "Presentation"
        div ! className "navbar-brand" ! style "float: right;" $ text $ "Slide " <> show ( pres ^. number) <> "/" <> show (pres ^. size)
    div ! className "container" $ do
      render $ pres ^. content

view :: State -> HTML Event
view app = maybe noslide slide $ app ^. presentation
