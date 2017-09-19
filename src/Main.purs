module Main where

import Prelude hiding (div)
import Control.Monad.Eff (Eff)
import Pux (CoreEffects, EffModel, start)
import Pux.Renderer.React (renderToDOM)
import UI.View(Event(..), view)
import Model.Presentation as P
import Model.State as S

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

type State = S.State

initialState :: State
initialState = { presentation: P.create slideSource } -- temporary


handle :: Event -> State -> State
handle Next s = s { presentation = P.next s.presentation }
handle Previous s = s { presentation = P.previous s.presentation }
handle Restart s = s { presentation = P.reset s.presentation }

foldp :: ∀ fx. Event -> State -> EffModel State Event fx
foldp ev s = { state: handle ev s, effects: [] }


main :: ∀ fx. Eff (CoreEffects fx) Unit
main = do
  app <- start
    { initialState
    , view
    , foldp
    , inputs: []
    }
  renderToDOM "#app" app.markup app.input
