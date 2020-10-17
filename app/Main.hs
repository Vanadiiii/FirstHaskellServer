module Main where

import System.Environment (getArgs)
import Lib                (server)

main = do
  [port'] <- getArgs
  server (fromIntegral $ read port')
