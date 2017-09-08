#!/usr/bin/env stack
-- stack --install-ghc --resolver lts-8.17 runghc --package cloud-seeder-0.1.0.0 --package optparse-applicative-0.14.0.0


{-# LANGUAGE OverloadedStrings #-}

import Network.CloudSeeder





main :: IO ()
main = putStrLn "hi"
