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
import Model.Presentation.New (create, Presentation)
import Model.App (newApp, presentation)

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
