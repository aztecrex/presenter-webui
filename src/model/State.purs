module Model.State (
    initial,
    presentation,
    presentation',
    State
    ) where

import Optic.Core
import Model.Presentation as P


type State = {
  presentation :: P.Presentation
}

initial :: State
initial = { presentation: P.initial }

presentation :: State -> P.Presentation
presentation = _.presentation

presentation' :: Lens' State P.Presentation
presentation' = lens  _.presentation  (\s p -> s { presentation = p } )

