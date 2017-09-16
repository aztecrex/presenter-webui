module Content.Markdown (proto, go, go2) where


-- import Text.Markdown.SlamDown
-- import Text.Markdown.SlamDown.Parser


import Prelude (Unit)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

foreign import go :: String -> Unit
foreign import go2 :: String -> Unit

proto :: ∀ fx. Eff ( console :: CONSOLE | fx ) Unit
proto = do
  log "hi"
