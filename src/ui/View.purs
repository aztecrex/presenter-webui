module UI.View.New (view) where

import Prelude (const, discard, show, ($), (<>))
import Data.Maybe (maybe)
import Text.Smolder.Markup (text, (#!))
import Text.Smolder.HTML (div, p, button, br)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Data.Lens ((^.))
import Model.App (App, presentation)
import Model.Presentation.New (Presentation, content, number, size)
import Content.Render(render)
import UI.Event(Event(..))

noslide :: HTML Event
noslide = div $ p $ text "No slide."

slide :: Presentation -> HTML Event
slide pres = do
    button #! onClick (const Previous) $ text "Previous"
    button #! onClick (const Next) $ text "Next"
    button #! onClick (const Restart) $ text "Restart"
    br
    div $ text $ "Slide "
      <> show ( pres ^. number)
      <> "/"
      <> show (pres ^. size)
    br
    render $ pres ^. content

view :: App -> HTML Event
view app = maybe noslide slide $ app ^. presentation
