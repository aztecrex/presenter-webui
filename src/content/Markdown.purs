module Content.Markdown (proto) where


-- import Text.Markdown.SlamDown
-- import Text.Markdown.SlamDown.Parser

import Prelude (Unit)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

proto :: ∀ fx. Eff ( console :: CONSOLE | fx ) Unit
proto = do
  log "hi"
