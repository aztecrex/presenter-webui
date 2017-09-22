module UI.Control (
  reduce
) where

import Prelude
import Data.Either
import Data.Maybe
import Data.Lens
import Model.App (App, presentation, _presentation)
import Model.Presentation.New (create, number)
import UI.Event (Event(..))

reduce :: Event -> App -> App
reduce (Content source) app = app # presentation .~ load
    where load  = either (const Nothing) Just $ create source
reduce Next app = app # _presentation <<< number +~ 1
reduce Previous app = app # _presentation <<< number -~ 1
reduce Restart app = app # _presentation <<< number .~ 1
reduce _ app = app
