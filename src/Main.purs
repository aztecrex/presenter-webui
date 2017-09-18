module Main where

import Prelude hiding (div)
import Data.List (List, length, (!!))
import Data.Maybe(Maybe(..))
import Data.Either (Either(..))
import Control.Monad.Eff (Eff)
import Pux (CoreEffects, EffModel, start)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Pux.Renderer.React (renderToDOM)
import Text.Smolder.HTML (button, div, br, p)
import Text.Smolder.Markup (text, (#!))
import Text.Markdown.SlamDown (SlamDown)
import Text.Markdown.SlamDown.Parser (parseMd)
import Content.Slide (slides)
import Content.Render (render)

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

load :: String -> Either String (List SlamDown)
load src = map slides (parseMd src)

type State = {
  index :: Int,
  maybePresentation :: Either String (List SlamDown)
}

initialState :: State
initialState = { index: 1, maybePresentation: load slideSource }

numSlides :: State -> Int
numSlides { index: _, maybePresentation: Left err} = 0
numSlides { index: _, maybePresentation: Right ss} = length ss

renderSlide :: forall b. Int -> List SlamDown -> HTML b
renderSlide index slides = case slides !! (index - 1) of
   Nothing -> div $ p $ text "Out of range"
   Just md -> render md

content :: forall a. State -> HTML a
content { index: _, maybePresentation: Left err} = div $ p $ text $ "No slides. " <> err
content { index: i, maybePresentation: Right ss} = renderSlide i ss


foldp :: ∀ fx. Event -> State -> EffModel State Event fx
foldp Next s = { state: s {index = if s.index >= numSlides s then numSlides s else s.index + 1 }, effects: [] }
foldp Previous s  = { state: s { index =  if s.index <= 1 then 1 else s.index - 1 }, effects: [] }
foldp Restart s = { state: initialState, effects: [] }

view :: State -> HTML Event
view state =
  div do
    button #! onClick (const Previous) $ text "Previous"
    button #! onClick (const Next) $ text "Next"
    button #! onClick (const Restart) $ text "Restart"
    br
    div $ text $ "Slide " <> (show state.index) <> "/" <> show (numSlides state)
    br
    content state


main :: ∀ fx. Eff (CoreEffects fx) Unit
main = do
  app <- start
    { initialState
    , view
    , foldp
    , inputs: []
    }
  renderToDOM "#app" app.markup app.input
