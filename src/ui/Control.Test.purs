module UI.Control.Test (tests) where

import Prelude (Unit)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Aff.AVar (AVAR)
-- import Model.State as S
-- import Model.Presentation as P
import Test.Unit (suite, test)
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (equal)

-- import UI.View (Event(..))

tests :: ∀ fx. Eff ( console :: CONSOLE
                  , testOutput :: TESTOUTPUT
                  , avar :: AVAR
                  | fx
          ) Unit
tests = do
  runTest do
    suite "UI.Control" do
        test "reset does (not really implemented yet)" do
          let actual = true
          let expected = true
          equal expected actual
