module UI.View (view) where

import Prelude (($), discard, const, (<>), show)
import Data.Maybe (Maybe(..))
import Text.Smolder.Markup (text, (#!))
import Text.Smolder.HTML (div, p, button, br)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Model.State (State, presentation)
import Model.Presentation (slide, size)
import Content.Render(render)
import UI.Event(Event(..))

view :: forall a. State -> HTML Event
view state = do
  let pres = presentation state
  case slide pres of
     Nothing -> div $ p $ text "No slide."
     Just {number, content} -> do
        button #! onClick (const Previous) $ text "Previous"
        button #! onClick (const Next) $ text "Next"
        button #! onClick (const Restart) $ text "Restart"
        br
        div $ text $ "Slide " <> (show number) <> "/" <> show (size pres)
        br
        render content

