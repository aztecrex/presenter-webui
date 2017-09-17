module Content.Render (render) where

import Prelude hiding (div)
import Data.List(List(..), (:))
import Data.Traversable(traverse_)
import Data.Foldable(intercalate)
import Text.Markdown.SlamDown(SlamDownP(..), Block(..), Inline(..), CodeBlockType(..))
import Text.Smolder.Markup (Markup, MarkupM(..), text)
import Text.Smolder.HTML (hr, p, div, code, pre)

render :: forall a. SlamDownP ~> Markup
render (SlamDown blocks) = div $ traverse_ renderBlock blocks

renderBlock :: forall a. Block ~> Markup
renderBlock (Paragraph spans) = p $ traverse_ renderInline spans
renderBlock (CodeBlock (Fenced _ _) lines) = pre $ code $ text $ intercalate "\n" lines
renderBlock _ = p (text "Block conversion not implemented.")

renderInline :: forall a. Inline ~> Markup
renderInline (Str txt) = text txt
renderInline _ = text "Inline conversion not implemented."
