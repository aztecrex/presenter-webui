module UI.Control (
  reduce
) where

import Prelude (const, (#), ($), (<<<))
import Data.Either (either)
import Data.Maybe (Maybe(..))
import Data.Lens ((+~), (-~), (.~))
import Model.State (State, presentation, _presentation, requestedLocation)
import Model.Presentation (create, number)
import UI.Event (Event(..))

reduce :: Event -> State -> State
reduce (Content source) app = app # presentation .~ load
    where load  = either (const Nothing) Just $ create source
reduce Next app = app # _presentation <<< number +~ 1
reduce Previous app = app # _presentation <<< number -~ 1
reduce Restart app = app # _presentation <<< number .~ 1
reduce (RemoteControl url newNumber) app = (updateLoc <<< updateNumber) app
        where updateNumber s = s # _presentation <<< number .~ newNumber
              updateLoc s = s # requestedLocation .~ url
reduce _ app = app
