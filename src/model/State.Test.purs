module Model.State.Test (tests) where

import Prelude (Unit, not, ($), id, map, const, discard)
import Data.List (List(..))
import Data.Either (either)
import Text.Markdown.SlamDown (SlamDown)
import Text.Markdown.SlamDown.Parser (parseMd)
import Content.Slide (slides)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Aff.AVar (AVAR)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (assert, equal)
import Test.Unit.Console (TESTOUTPUT)

import Model.State(initial, presentation, presentable, install, size)

tests :: ∀ fx. Eff ( console :: CONSOLE
                  , testOutput :: TESTOUTPUT
                  , avar :: AVAR
                  | fx
          ) Unit
tests = do
  runTest do
    suite "Model.State" do
      test "initial presentation is not presentable" do
        assert "should be not presentable" $ not $ presentable $ presentation initial
      test "install slides" do
        let newState = install testSource initial
        let pres = presentation newState
        let actual = size pres
        let expected = 3
        equal expected actual


testSlides :: List SlamDown
testSlides = either (const Nil) id $ map slides $ parseMd testSource

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
