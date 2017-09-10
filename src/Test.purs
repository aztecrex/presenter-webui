module Test.Main where

-- import Prelude
-- import Control.Monad.Eff (Eff)
-- import Control.Monad.Eff.Console (CONSOLE)
-- import Control.Monad.Aff.AVar (AVAR)
-- import Test.Unit (suite, test)
-- import Test.Unit.Console (TESTOUTPUT)
-- import Test.Unit.Main (runTest)
-- import Test.Unit.Assert as Assert
import Provision.Test (provisionTest)

-- main :: ∀ fx. Eff ( console :: CONSOLE
--                   , testOutput :: TESTOUTPUT
--                   , avar :: AVAR
--                   | fx
--           ) Unit
main = do
  provisionTest
