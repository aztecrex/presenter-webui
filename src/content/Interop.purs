module Content.Interop (getSource) where

import Prelude (bind, pure, show, ($))
import Data.Either (either)
import Control.Monad.Aff (attempt, Aff)
import Network.HTTP.Affjax (AJAX, get)


getSource :: forall r.
      String
      -> Aff
        ( ajax :: AJAX
        | r
        )
        String
getSource url = do
  res <- attempt $ get url
  let decode r = r.response
  pure $ either show decode res
