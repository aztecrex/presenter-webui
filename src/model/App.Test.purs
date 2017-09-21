module Model.App.Test (tests) where

import Prelude (Unit, ($), discard, (#))
import Data.Either (fromRight)
import Data.Maybe (Maybe(..))
import Partial.Unsafe (unsafePartial)
import Optic.Core
import Model.Presentation as PO
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Aff.AVar (AVAR)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (equal)
import Test.Unit.Console (TESTOUTPUT)
import Model.Presentation.New as P

import Model.App as A
import Model.State(initial, presentation)

tests :: ∀ fx. Eff ( console :: CONSOLE
                  , testOutput :: TESTOUTPUT
                  , avar :: AVAR
                  | fx
          ) Unit
tests = do
  runTest do
    -- suite "Model.App" do
    --   test "assign presentation" do
    --       let actual = A.create # A.presentation .~ testPres
    --       equal (Just testPres) (actual ^. A.presentation)
    suite "Model.State" do
      test "initial presentation" do
        equal 0 (PO.size $ presentation initial)
        equal false (PO.presentable $ presentation initial)

testPres :: P.Presentation
testPres = unsafePartial $ fromRight $ P.create testSource

testSource :: String
testSource = """
# Slide One

On this slide we have lots of coolness.

---
# Slide Two

## Let me tell you

This is weird.

## Let me tell you something else

_Really_ weird.

---
# Final Slide

Wasn't that just the greatest presentation?

"""
