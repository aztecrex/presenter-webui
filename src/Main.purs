module Main where

import Prelude hiding (div)
import Data.Maybe(Maybe(..))
import Control.Monad.Eff (Eff)
import Pux (CoreEffects, EffModel, start)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Pux.Renderer.React (renderToDOM)
import Text.Smolder.HTML (button, div, br, p)
import Text.Smolder.Markup (text, (#!))
import Content.Render (render)
import Model.Presentation as P

data Event = Next | Previous | Restart

slideSource :: String
slideSource = """
# Slide One

On this slide we have lots of coolness.

---
# Slide Two

## Let me tell you

This is weird.

## Let me tell you something else

_Really_ weird.

---
# Final Slide

Wasn't that just the greatest presentation?

"""

type State = P.Presentation

initialState :: State
initialState = P.create slideSource

numSlides :: State -> Int
numSlides = P.size

handle :: Event -> State -> State
handle Next s = P.next s
handle Previous s = P.previous s
handle Restart s = P.reset s

foldp :: ∀ fx. Event -> State -> EffModel State Event fx
foldp ev s = { state: handle ev s, effects: [] }

view :: State -> HTML Event
view state =
  case P.slide state of
     Nothing -> div $ p $ text "No slide."
     Just {number, content} -> do
        button #! onClick (const Previous) $ text "Previous"
        button #! onClick (const Next) $ text "Next"
        button #! onClick (const Restart) $ text "Restart"
        br
        div $ text $ "Slide " <> (show number) <> "/" <> show (P.size state)
        br
        render content

main :: ∀ fx. Eff (CoreEffects fx) Unit
main = do
  app <- start
    { initialState
    , view
    , foldp
    , inputs: []
    }
  renderToDOM "#app" app.markup app.input
