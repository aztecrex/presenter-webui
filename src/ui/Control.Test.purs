module UI.Control.Test (tests) where

import Prelude
import Partial.Unsafe (unsafePartial)
import Data.Either (either, fromRight)
import Data.Maybe (Maybe(..))
import Data.Lens
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Aff.AVar (AVAR)
import Test.Unit (suite, test)
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (equal)
import UI.Event (Event(..))
import Model.Presentation.New
import Model.App

import UI.Control (reduce)

tests :: ∀ fx. Eff ( console :: CONSOLE
                  , testOutput :: TESTOUTPUT
                  , avar :: AVAR
                  | fx
          ) Unit
tests = do
  runTest do
    suite "UI.Control" do
        test "change slides" do
          let event = Content testSource
          let initial = newApp # presentation .~ Just (makePres "# was")
          let actual = reduce event initial
          let expected = newApp # presentation .~ Just testPres
          equal expected actual
        test "install slides" do
          let event = Content testSource
          let initial = newApp
          let actual = reduce event initial
          let expected = newApp # presentation .~ Just testPres
          equal expected actual
        test "next" do
          let event = Next
          let initial = testApp
          let actual = reduce event initial
          let expected = initial # _presentation <<< number +~ 1
          equal expected actual
        test "previous" do
          let event = Previous
          let initial = testApp # _presentation <<< number .~ 3
          let actual = reduce event initial
          let expected = initial # _presentation <<< number -~ 1
          equal expected actual

testApp :: App
testApp = newApp # presentation .~ Just testPres

makePres :: String -> Presentation
makePres src = unsafePartial $ fromRight $ create src

testPres :: Presentation
testPres = makePres testSource

testSource :: String
testSource = """# Slide 1
---
# Slide 2
---
# Slide 3
---
# Slide 4
---
# Slide 5
"""
