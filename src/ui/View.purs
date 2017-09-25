module UI.View (view) where

import Prelude (const, discard, show, ($), (<>))
import Data.Maybe (maybe)
import Text.Smolder.Markup (text, (#!), (!))
import Text.Smolder.HTML (div, p, button, h3, a, span)
import Text.Smolder.HTML.Attributes (href, className)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Data.Lens ((^.))
import Model.State (State, presentation)
import Model.Presentation (Presentation, content, number, size)
import Content.Render(render)
import UI.Event(Event(..))

noslide :: HTML Event
noslide = div $ p $ text "No slide."

      -- <div class="navbar navbar-inverse">
      --   <div class="container">
      --     <a class="navbar-brand" href="/">Presentation</a>
      --   </div>
      -- </div>
      -- <div class="container">
      --   <div id="app"/ ></div>
      -- </div>



slide :: Presentation -> HTML Event
slide pres = do
    div ! className "navbar navbar-inverse" $ do
      div ! className "container" $ do
        a ! className "navbar-brand" ! href "/" $ text "Presentation"
        span ! className "navbar-brand" $ text $ show ( pres ^. number) <> "/" <> show (pres ^. size)
    div ! className "container" $ do
      render $ pres ^. content

view :: State -> HTML Event
view app = maybe noslide slide $ app ^. presentation
