module AWS.Cognito (asyncLog) where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Aff

foreign import _request :: forall eff. (Error -> Eff (console :: CONSOLE | eff) Unit) -> (String -> Eff (console :: CONSOLE | eff) Unit) -> String -> Eff (console :: CONSOLE | eff) Unit

asyncLog :: forall eff. String -> Aff (console :: CONSOLE | eff) String
asyncLog message = makeAff (\error success -> _request error success message)



-- ajaxGet' :: forall e. Request -> Aff e Response
-- ajaxGet' req = makeAff (\error success -> ajaxGet success req)

-- foreign import _request :: forall eff. String -> EffFnAff (ajax :: CONSOLE | eff) String

-- asyncLog :: forall eff. String -> Aff (ajax :: CONSOLE | eff) String
-- asyncLog = fromEffFnAff <<< _request

-- -- asyncLog :: forall eff. String -> Aff (console :: CONSOLE | eff ) String
-- -- asyncLog = pure

