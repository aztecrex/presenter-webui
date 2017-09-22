module UI.Control (
  reduce
) where

import Prelude
import Data.Either
import Data.Maybe
import Data.Lens
import Model.App (App, presentation)
import Model.Presentation.New (create, Presentation)
import UI.Event (Event(..))

reduce :: Event -> App -> App
reduce (Content source) app = app # presentation .~ load
    where load  = either (const Nothing) Just $ create source
reduce _ app = app
