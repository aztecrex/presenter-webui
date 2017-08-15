module Main where

import Prelude hiding (div)
import Control.Monad.Eff (Eff)
import Pux (CoreEffects, EffModel, start)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Pux.Renderer.React (renderToDOM)
import Text.Smolder.HTML (button, div, br)
import Text.Smolder.Markup (text, (#!))

data Event = Next | Previous | Restart

type State = Int

initial :: State
initial = 1

foldp :: ∀ fx. Event -> State -> EffModel State Event fx
foldp Next s = { state: s + 1, effects: [] }
foldp Previous s  = { state: if s <= 1 then 1 else s - 1, effects: [] }
foldp Restart s = { state: initial, effects: [] }

view :: State -> HTML Event
view slide =
  div do
    div $ text $ "Slide " <> (show slide)
    br
    button #! onClick (const $ Previous) $ text "Previous"
    button #! onClick (const $ Next) $ text "Next"
    button #! onClick (const $ Restart) $ text "Restart"


main :: ∀ fx. Eff (CoreEffects fx) Unit
main = do
  app <- start
    { initialState: initial
    , view
    , foldp
    , inputs: []
    }
  renderToDOM "#app" app.markup app.input
