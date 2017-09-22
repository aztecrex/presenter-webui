module Model.App.Test (tests) where

import Prelude (Unit, discard, (#), ($), (/=), (==))
import Data.Either (fromRight)
import Data.Maybe (Maybe(..))
import Partial.Unsafe (unsafePartial)
import Data.Lens ((.~), (^.), (^?))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Aff.AVar (AVAR)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (assert, equal)
import Test.Unit.Console (TESTOUTPUT)
import Model.Presentation.New (create, Presentation)

import Model.App (newApp, presentation, presentationError)

tests :: ∀ fx. Eff ( console :: CONSOLE
                  , testOutput :: TESTOUTPUT
                  , avar :: AVAR
                  | fx
          ) Unit
tests = do
  runTest do
    suite "Model.App" do
      test "no initial presentation" do
        equal Nothing $ newApp ^. presentation
      test "initial presentation error" do
        equal (Just "uninitialized") $ newApp ^? presentationError
      test "presentation" do
        let actual = (newApp # presentation .~ testSource) ^. presentation
        equal (Just testPres) actual
      test "equality" do
        let a = newApp # presentation .~ "# Slide"
        let b = newApp # presentation .~ "# Slide"
        let other = newApp # presentation .~ "not a slide"
        assert "equal" $ a == b
        assert "commute" $ b == a
        assert "symmetry" $ a == a
        assert "not equal" $ a /= newApp
        assert "not equal" $ a /= other


testPres :: Presentation
testPres = unsafePartial $ fromRight $ create testSource

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
