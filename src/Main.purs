module Main where

import Prelude (Unit, bind, ($), pure, discard, show, (<>))
import Data.Maybe (Maybe(..))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Aff (Aff)
import Pux (CoreEffects, EffModel, start)
import Pux.Renderer.React (renderToDOM)
import Signal (constant)
import Network.HTTP.Affjax (AJAX)
import Content.Interop (getSource)
import UI.View (view)
import UI.Event (Event(..))
import UI.Control (reduce)
import Model.State (State, newState)
import AWS.Cognito (asyncLog, identityId)


logEvent :: forall eff. Event -> Aff (console :: CONSOLE | eff) (Maybe Event)
logEvent ev = do
  result <- asyncLog $ show ev
  liftEff $ log result
  pure Nothing

logIdentity :: forall eff. Aff (console :: CONSOLE | eff) (Maybe Event)
logIdentity = do
  idid <- identityId
  liftEff $ log $ "cognito identity: " <> idid
  pure Nothing

initialState :: State
initialState = newState

type AppEffects = (console :: CONSOLE, ajax :: AJAX)

foldp :: ∀ fx. Event -> State -> EffModel State Event (console :: CONSOLE, ajax :: AJAX | fx)
foldp RequestContent s = { state: reduce RequestContent s,
  effects: [do
    liftEff $ log "content requested!!!"
    src <- getSource
    pure $ Just $ Content src
  ] }
foldp ev s = { state: reduce ev s, effects: [logIdentity] }

main :: Eff (CoreEffects AppEffects) Unit
main = do
  app <- start
    { initialState
    , view
    , foldp
    , inputs: [ constant RequestContent ]
    }
  renderToDOM "#app" app.markup app.input


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
