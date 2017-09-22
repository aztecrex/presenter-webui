module Main where

import Prelude hiding (div)
import Control.Monad.Eff (Eff)
import Pux (CoreEffects, EffModel, start)
import Pux.Renderer.React (renderToDOM)
import UI.View (view)
import UI.Event (Event(..))
-- import UI.Control (reduce)
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

-- reduce :: Event -> State -> State
-- reduce Next s = s { presentation = P.next s.presentation }
-- reduce Previous s = s { presentation = P.previous s.presentation }
-- reduce Restart s = s { presentation = P.reset s.presentation }
-- reduce _ s = s

reduce :: Event -> State -> State
reduce _ = id

foldp :: ∀ fx. Event -> State -> EffModel State Event fx
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
