module Content.Render (render) where

import Prelude ((<>), type (~>), ($), show)
import Data.List(List(..), (:))
import Data.Traversable(traverse_)
import Data.Foldable(intercalate)
import Text.Markdown.SlamDown(SlamDownP(..), Block(..), Inline(..), CodeBlockType(..), ListType(..), LinkTarget(..))
import Text.Smolder.Markup (Markup, MarkupM(..), text, (!), parent)
import Text.Smolder.HTML (hr, p, div, code, pre, ol, ul, li, blockquote, a, strong, em, br)
import Text.Smolder.HTML.Attributes (className, href)

render :: forall a. SlamDownP ~> Markup
render (SlamDown blocks) = div $ traverse_ renderBlock blocks

renderBlock :: forall a. Block ~> Markup
renderBlock (Paragraph spans) = p $ traverse_ renderInline spans
renderBlock (CodeBlock (Fenced _ "") lines) = pre $ code $ text $ intercalate "\n" lines
renderBlock (CodeBlock (Fenced _ language) lines) = pre $ code ! className ("language-" <> language) $ text $ intercalate "\n" lines
renderBlock (CodeBlock Indented lines) = pre $ code $ text $ intercalate "\n" lines
renderBlock (Lst (Ordered _) items) = ol $ traverse_ (traverse_ paragraphToLine) items
renderBlock (Lst (Bullet _) items) = ul $ traverse_ (traverse_ paragraphToLine) items
renderBlock (Blockquote blocks) = blockquote $ traverse_ renderBlock blocks
renderBlock (Header level spans) = parent ("h" <> show level) $ traverse_ renderInline spans
renderBlock (LinkReference label dest) = a ! href dest $ text label
renderBlock _ = p (text "Block conversion not implemented.")

renderInline :: forall a. Inline ~> Markup
renderInline (Str txt) = text txt
renderInline Space = text " "
renderInline (Code _ txt) = code $ text txt
renderInline (Strong spans) = strong $ traverse_ renderInline spans
renderInline (Emph spans) = em $ traverse_ renderInline spans
renderInline SoftBreak = text "\n"
renderInline LineBreak = br
renderInline (Entity txt) = text txt
renderInline (Link spans (InlineLink dest)) = a ! href dest $ traverse_ renderInline spans
renderInline _ = text "Inline conversion not implemented."

paragraphToLine :: forall a. Block ~> Markup
paragraphToLine (Paragraph spans) = li $ traverse_ renderInline spans
paragraphToLine b = renderBlock b
