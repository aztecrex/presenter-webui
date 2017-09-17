module Content.Render (render) where

import Prelude hiding (div)
import Data.List(List(..), (:))
import Text.Markdown.SlamDown(SlamDownP(..), Block(..), Inline(..))
import Text.Smolder.Markup (Markup, MarkupM(..), text)
import Text.Smolder.HTML (hr, p, div)

render :: forall a. SlamDownP ~> Markup
render (SlamDown (Paragraph (Str txt : Nil) : Nil)) = div (p (text txt) )
render _ = hr
