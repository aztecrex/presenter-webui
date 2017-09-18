module Model.State.Test (tests) where

import Prelude (Unit, ($), discard)
import Model.Presentation as P
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Aff.AVar (AVAR)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (equal)
import Test.Unit.Console (TESTOUTPUT)

import Model.State(initial, presentation)

tests :: ∀ fx. Eff ( console :: CONSOLE
                  , testOutput :: TESTOUTPUT
                  , avar :: AVAR
                  | fx
          ) Unit
tests = do
  runTest do
    suite "Model.State" do
      test "initial presentation" do
        equal 0 (P.size $ presentation initial)
        equal false (P.presentable $ presentation initial)
