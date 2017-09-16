module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Aff.AVar (AVAR)
import Test.Unit.Console (TESTOUTPUT)
import Provision.Test (provisionTest)
import Content.Markdown (go, go2)


text :: String
text = """
# this is cool

we need some

- thing 1
  - thing 1.1
  - thing 1.2
- thing 2

---

# another page


here is some text spanning
multiple lines forming
a paragrah with a [link](http://gregwiley.com).

"""

main :: ∀ fx. Eff ( console :: CONSOLE
                  , testOutput :: TESTOUTPUT
                  , avar :: AVAR
                  | fx
          ) Unit
main = do
  -- provisionTest
  log text
  pure $ go text
  pure $ go2 text
