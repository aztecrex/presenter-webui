module Content.Render.Test (tests) where

import Prelude (Unit, ($), (==), (<<<), discard)
import Data.List (singleton, (:), List(..))
import Text.Markdown.SlamDown (SlamDown, SlamDownP(..), Block(..), Inline(..))
import Text.Smolder.HTML (div, p)
import Text.Smolder.Markup (text, Markup)
import Text.Smolder.Renderer.String as MR
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Aff.AVar (AVAR)
import Test.Unit (suite, test, Test)
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (assert, equal)

import Content.Render (render)

blockp :: forall a. String -> Block a
blockp txt = Paragraph $ singleton $ Str txt

singletonMd :: forall a. Block a -> SlamDownP a
singletonMd = SlamDown <<< singleton

paragraphMd :: forall a. String -> SlamDownP a
paragraphMd = singletonMd <<< blockp

tests :: ∀ fx. Eff ( console :: CONSOLE
                  , testOutput :: TESTOUTPUT
                  , avar :: AVAR
                  | fx
          ) Unit
tests = do
  runTest do
    suite "Content.Render" do
        test "convert paragraph" do
            let ptext = "such text!"
            let source = paragraphMd ptext
            let expected = div $ do
                             p $ text ptext
            check source expected
        test "convert multiple paragraphs" do
            let ptext1 = "such text!"
            let ptext2 = "such more text!"
            let source = SlamDown (blockp ptext1 : blockp ptext2 : Nil)
            let expected = div $ do
                             p $ text ptext1
                             p $ text ptext2
            check source expected


check :: forall e a. SlamDown -> Markup a -> Test (console :: CONSOLE | e)
check source expected = do
    let actual = render source
    equal (MR.render expected) (MR.render actual)
