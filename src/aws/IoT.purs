module AWS.IoT (Update(..), updates) where

import Prelude
import Control.Monad.Eff
import Control.Monad.Eff.Exception
import Control.Monad.Eff.Class
import Control.Monad.Eff.Console
import Control.Monad.Aff
import Signal
import Signal.Channel
import Signal.Time
import AWS.Types (AWS, Credentials)
import AWS

foreign import data ForeignUpdate :: Type
foreign import _updates :: forall eff.
    Credentials
    -> (ForeignUpdate -> Eff (aws :: AWS | eff) Unit)
    -> Eff (aws :: AWS | eff) Unit

foreign import _pageUpdate :: ForeignUpdate -> Int
foreign import _urlUpdate :: ForeignUpdate -> String
foreign import _rawUpdate :: ForeignUpdate -> String

data Update = Update String Int String | InitialUpdate

fromForeignUpdate :: ForeignUpdate -> Update
fromForeignUpdate fu = Update (_urlUpdate fu) (_pageUpdate fu) (_rawUpdate fu)

fromUpdates :: forall eff.
    Credentials
    -> (Update -> Eff (aws :: AWS | eff) Unit)
    -> Eff (aws :: AWS | eff) Unit
fromUpdates credentials handle = _updates credentials (\fu -> handle (fromForeignUpdate fu))

updates :: forall eff.
    Eff
        ( channel :: CHANNEL, aws :: AWS, exception :: EXCEPTION
        | eff
        )
        (Signal Update)
updates = do
    ch <- channel InitialUpdate
    let sink = send ch
    void $ launchAff $ do
        creds <- credentials
        liftEff $ fromUpdates creds sink
    pure $ subscribe ch
