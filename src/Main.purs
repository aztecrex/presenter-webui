module Main where

import Prelude (Unit, bind)
import Control.Monad.Eff (Eff)
import Pux (CoreEffects, EffModel, start)
import Pux.Renderer.React (renderToDOM)
import UI.View.New (view)
import UI.Event (Event(..))
import UI.Control (reduce)
import Model.App (App, newApp)

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

initialState :: App
initialState = reduce (Content slideSource) newApp


foldp :: ∀ fx. Event -> App -> EffModel App Event fx
foldp ev s = { state: reduce ev s, effects: [] }

main :: ∀ fx. Eff (CoreEffects fx) Unit
main = do
  app <- start
    { initialState
    , view
    , foldp
    , inputs: []
    }
  renderToDOM "#app" app.markup app.input
