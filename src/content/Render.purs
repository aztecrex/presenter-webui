module Content.Render (render) where

import Prelude hiding (div)
import Data.List(List(..), (:))
import Data.Traversable(traverse_)
import Text.Markdown.SlamDown(SlamDownP(..), Block(..), Inline(..))
import Text.Smolder.Markup (Markup, MarkupM(..), text)
import Text.Smolder.HTML (hr, p, div)

render :: forall a. SlamDownP ~> Markup
render (SlamDown blocks) = div $ traverse_ renderBlock blocks

renderBlock :: forall a. Block ~> Markup
renderBlock (Paragraph (Str txt : Nil)) = p (text txt)
renderBlock _ = p (text "Conversion not implemented.")
