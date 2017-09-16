module Content.Markdown (proto, go, go2, wat, Carl) where

import Data.Either
import Data.Maybe
import Data.Int as INT
import Text.Markdown.SlamDown
import Text.Markdown.SlamDown.Parser
import Text.Markdown.SlamDown.Pretty
import Text.Markdown.SlamDown.Syntax
import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)


go :: String -> Unit
go = const unit
go2 :: String -> Unit
go2 = const unit

newtype Carl = Carl Int

instance eqCarl :: Eq Carl where
  eq (Carl a) (Carl b) = eq a b

instance ordCarl :: Ord Carl where
  compare (Carl a) (Carl b) = compare a b

instance carlShow :: Show Carl where
  show (Carl x) = show x

readCarl :: String -> Carl
readCarl s = Carl $ maybe 0 id (INT.fromString s)

instance valueCarl :: Value Carl where
  renderValue = show
  stringValue = readCarl

wat :: String -> Either String String
wat s = map prettyPrintMd $ (parseMd s :: Either String (SlamDownP Carl))

proto :: ∀ fx. Eff ( console :: CONSOLE | fx ) Unit
proto = do
  pure unit
