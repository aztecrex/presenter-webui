module Content.Render (render) where

import Prelude (id)

render :: forall a. a -> a
render = id
