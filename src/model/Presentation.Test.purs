module Model.Presentation.Test (tests) where

import Prelude (Unit, not, ($), id, map, const, discard)
import Data.List (List(..), (!!))
import Data.Either (either)
import Data.Maybe (Maybe(..), isJust)
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

tests :: ∀ fx. Eff ( console :: CONSOLE
                  , testOutput :: TESTOUTPUT
                  , avar :: AVAR
                  | fx
          ) Unit
tests = do
  runTest do
    suite "Model.Presentation" do
      test "initial presentation is not presentable" do
        assert "should be not presentable" $ not $ presentable $ initial
      test "create" do
        let pres = create testSource
        let actual = size pres
        let expected = 3
        equal expected actual
      test "get slide not presentable" do
        assert "no slide" $ not $ isJust (slide initial)
      test "get presentable slide" do
        let s = slide $ create testSource
        let actualContent = map _.content s
        let actualNumber = map _.number s
        equal (testSlides !! 0) actualContent
        equal (Just 1) actualNumber
      test "next not presentable" do
        assert "not presentable" $ not $ presentable $ next initial
      test "previous not presentable" do
        assert "not presentable" $ not $ presentable $ previous initial
      test "reset not presentable" do
        assert "not presentable" $ not $ presentable $ reset initial
      test "next presentable" do
        let pres = create testSource
        let actual = slide $ next pres
        let actualContent = map _.content actual
        let actualNumber = map _.number actual
        equal (testSlides !! 1) actualContent
        equal (Just 2) actualNumber
      test "previous presentable" do
        let pres = create testSource
        let actual = slide $ previous $ next $ next pres
        let actualContent = map _.content actual
        let actualNumber = map _.number actual
        equal (testSlides !! 1) actualContent
        equal (Just 2) actualNumber
      test "reset presentable" do
        let pres = create testSource
        let actual = slide $ reset $ next $ next pres
        let actualContent = map _.content actual
        let actualNumber = map _.number actual
        equal (testSlides !! 0) actualContent
        equal (Just 1) actualNumber
      test "lower clamp presentable" do
        let pres = create testSource
        let actual = slide $ previous pres
        let actualContent = map _.content actual
        let actualNumber = map _.number actual
        equal (testSlides !! 0) actualContent
        equal (Just 1) actualNumber
      test "upper clamp presentable" do
        let pres = create testSource
        let actual = slide $ next $ next $ next $ next $ next pres
        let actualContent = map _.content actual
        let actualNumber = map _.number actual
        equal (testSlides !! 2) actualContent
        equal (Just 3) actualNumber



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
