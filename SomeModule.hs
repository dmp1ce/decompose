--{-# LANGUAGE OverloadedStrings #-}

module SomeModule where

import Prelude
import Turtle

something :: IO()
something = do                           --
  echo "Line 1"                   -- echo Line 1
  echo "Line 2"                   -- echo Line 2
  touch "aNewFile.txt"  

aString = "hello dude"
