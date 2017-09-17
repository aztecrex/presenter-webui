module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Aff.AVar (AVAR)
import Test.Unit.Console (TESTOUTPUT)
import Content.Slide.Test as Slide
import Content.Render.Test as Render
import Provision.Runtime.Test as Runtime

main :: ∀ fx. Eff ( console :: CONSOLE
                  , testOutput :: TESTOUTPUT
                  , avar :: AVAR
                  | fx
          ) Unit
main = do
  Slide.tests
  Render.tests
  Runtime.tests
