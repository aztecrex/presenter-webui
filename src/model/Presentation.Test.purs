module Model.Presentation.Test (tests) where

import Prelude (Unit, not, ($), id, map, const, discard, (<<<), (#), (-), (+), negate, (==), (/=))
import Data.List (List(..), (!!), length)
import Data.Either (Either, either, fromRight)
import Data.Maybe (Maybe(..), isJust, fromJust)
import Partial.Unsafe (unsafePartial)
-- import Optic.Core
import Data.Lens
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

import Model.Presentation(initial, create, presentable, size, slide, next, previous, reset)
import Model.Presentation.New as P

tests :: ∀ fx. Eff ( console :: CONSOLE
                  , testOutput :: TESTOUTPUT
                  , avar :: AVAR
                  | fx
          ) Unit
tests = do
  runTest do
    suite "Model.NewPresentation" do
      test "size" do
        let actual = testPres ^. P.size
        let expected = length testSlides
        equal expected actual
      test "slide content" do
        let actual = testPres ^. P.slide <<< P.content
        let expected = testSlide 0
        equal expected actual
      test "get slide number" do
        let actual = testPres ^. P.slide <<< P.number
        equal 1 actual
      test "change slide number" do
        let n = 3
        let updated = testPres # P.slide <<< P.number .~ n
        let actual = updated ^. P.slide <<< P.content
        let expected = testSlide (n - 1)
        equal expected actual
        equal n $ updated ^. P.slide <<< P.number
      test "slide number upper bound" do
        let updated = testPres # P.slide <<< P.number .~ 300
        let actual = updated ^. P.slide <<< P.content
        let expected = testSlide (length testSlides - 1)
        equal expected actual
        equal (length testSlides) $ updated ^. P.slide <<< P.number
      test "slide number lower bound" do
        let updated = testPres # P.slide <<< P.number .~ (0)
        let expected = testSlide 0
        equal (testSlide 0) $ updated ^. P.slide <<< P.content
        equal 1 $ updated ^. P.slide <<< P.number
      test "relative slide change" do
        let up = 2
        let down = 1
        let moved = ((testPres ^. P.slide) # P.number +~ up) # P.number -~ down
        equal (testSlide (up - down)) $ moved ^. P.content
        equal (1 + up - down) $ moved ^. P.number
      test "presentation equal" do
         let src = "# Slide"
         let a = unsafeCreatePres src
         let b = unsafeCreatePres src
         assert "they are equal" $ a == b
         assert "commutative" $ b == a
         assert "same" $ a == a
      test "presentation nequal" do
         let a = unsafeCreatePres "# Slide 1\n---\n# Slide 2"
         let b = unsafeCreatePres "# Slide"
         assert "they are noe equal" $ a /= b
         assert "commutative" $ b /= a




unsafeCreatePres :: String -> P.Presentation
unsafeCreatePres src = unsafePartial $ fromRight $ P.create src

testSlides :: List SlamDown
testSlides = unsafePartial fromRight $ map slides $ parseMd testSource

testSlide :: Int -> SlamDown
testSlide i = unsafePartial fromJust $ testSlides !! i

testPres :: P.Presentation
testPres = unsafeCreatePres testSource

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
