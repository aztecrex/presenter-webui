module Model.State (
    initial,
    presentation
    ) where

import Model.Presentation as P

type State = {
  presentation :: P.Presentation
}

initial :: State
initial = { presentation: P.initial }

presentation :: State -> P.Presentation
presentation = _.presentation
