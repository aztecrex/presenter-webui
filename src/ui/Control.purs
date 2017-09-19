module UI.Control where

import Prelude (id)
import Optic.Core
import Model.State (State, presentation')
import Model.Presentation (Presentation, next, previous, reset)
import UI.Event (Event(..))

getPres :: State -> Presentation
getPres = view presentation'

setPres :: Presentation -> State -> State
setPres = set presentation'

-- setPres :: State -> Presentation -> State


updatePres :: (Presentation -> Presentation) -> State -> State
updatePres = over presentation'

reduce :: Event -> State -> State
reduce Next = over presentation' next
reduce Previous = over presentation' previous
reduce Restart = over presentation' reset
reduce _ = id
