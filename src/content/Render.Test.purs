module Content.Render.Test (tests) where

import Prelude (Unit, ($), (==), (<>), (<<<), discard)
import Data.List (singleton, (:), List(..))
import Text.Markdown.SlamDown (SlamDown, SlamDownP(..), Block(..), Inline(..), CodeBlockType(..), ListType(..))
import Text.Smolder.HTML (div, p, pre, code, ol, ul, li)
import Text.Smolder.HTML.Attributes (className)
import Text.Smolder.Markup (text, Markup, (!))
import Text.Smolder.Renderer.String as MR
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Aff.AVar (AVAR)
import Test.Unit (suite, test, Test)
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (assert, equal)

import Content.Render (render)



para :: forall a. String -> Block a
para txt = Paragraph $ singleton $ Str txt

blockp :: forall a. String -> Block a
blockp = para

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
        test "convert multiple text" do
            let ptext1 = "such text!"
            let ptext2 = "such more text!"
            let ptext3 = "with addition"
            let source = SlamDown (blockp ptext1 : Paragraph  (Str ptext2 : Str ptext3 : Nil) : Nil)
            let expected = div $ do
                  p $ text ptext1
                  p $ do
                    text ptext2
                    text ptext3
            check source expected
        test "convert fenced code block" do
          let line1 = "line 1"
          let line2 = "line 2"
          let line3 = "line 3"
          let lines = line1 : line2 : line3 : Nil
          let source = singletonMd $ CodeBlock (Fenced true "") lines
          let expected = div $ do
                pre $ code $ text $
                  line1 <> "\n" <> line2 <> "\n" <> line3
          check source expected
        test "convert fenced code block with language" do
          let line1 = "line 1"
          let line2 = "line 2"
          let line3 = "line 3"
          let lines = line1 : line2 : line3 : Nil
          let source = singletonMd $ CodeBlock (Fenced true "cpp") lines
          let expected = div $ do
                pre $ code ! className "language-cpp" $ text $
                  line1 <> "\n" <> line2 <> "\n" <> line3
          check source expected
        test "convert indented code block" do
          let line1 = "line 1"
          let line2 = "line 2"
          let line3 = "line 3"
          let lines = line1 : line2 : line3 : Nil
          let source = singletonMd $ CodeBlock Indented lines
          let expected = div $ do
                pre $ code $ text $
                  line1 <> "\n" <> line2 <> "\n" <> line3
          check source expected
        test "convert ordered list" do
          let itext1 = "line 1"
          let itext2 = "line 2"
          let itext3 = "line 3"
          let codetext = "int x = 3.302"
          let items1 = blockp itext1 : CodeBlock Indented (singleton codetext) : Nil
          let items2 = blockp itext2 : blockp itext3 : Nil
          let source = SlamDown $ singleton $ Lst (Ordered "1.") (items1 : items2 : Nil)
          let expected = div $ do
                ol $ do
                  li $ text itext1
                  pre $ code $ text codetext
                  li $ text itext2
                  li $ text itext3
          check source expected
        test "convert unordered list" do
          let itext1 = "line 1"
          let itext2 = "line 2"
          let itext3 = "line 3"
          let codetext = "int x = 3.302"
          let items1 = blockp itext1 : CodeBlock Indented (singleton codetext) : Nil
          let items2 = blockp itext2 : blockp itext3 : Nil
          let source = SlamDown $ singleton $ Lst (Bullet "*") (items1 : items2 : Nil)
          let expected = div $ do
                ul $ do
                  li $ text itext1
                  pre $ code $ text codetext
                  li $ text itext2
                  li $ text itext3
          check source expected

check :: forall e a. SlamDown -> Markup a -> Test (console :: CONSOLE | e)
check source expected = do
    let actual = render source
    equal (MR.render expected) (MR.render actual)
