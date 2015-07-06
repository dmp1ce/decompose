{-# LANGUAGE OverloadedStrings #-}
--import Something
--import Commands
import Control.Monad
import Language.Haskell.Interpreter
import Turtle

main :: IO ()
main = do
  echo "List help here..."
  r <- runInterpreter testHint
  case r of
    Left err -> printInterpreterError err
    Right () -> putStrLn "that's all folks"
--main = do                           --
--    echo "Line 1"                   -- echo Line 1
--    echo "Line 2"                   -- echo Line 2

-- observe that Interpreter () is an alias for InterpreterT IO ()
testHint :: Interpreter ()
testHint =
  do
    --say "Listing available language extensions"
    --say $ show availableExtensions
    say "Set language extension"
    set [languageExtensions := [OverloadedStrings]]
    say "Listing language extensions"
    ttt <- get languageExtensions
    say $ show ttt
    say "Set Turtle import"
    setImports ["Turtle", "Prelude"]
    --say "Listing imports"
    --say $ show getLoadedModules
    --say $ show mymods
    say "Load SomeModule.hs"
    loadModules ["SomeModule.hs"]
    setTopLevelModules ["SomeModule"]
    -- Attempt to run interpreted commands
    interpretedString <- interpret "aString" (as :: String)
    say interpretedString
    doSomething <- interpret "something" (as :: IO())
    liftIO doSomething

say :: String -> Interpreter ()
say = liftIO . putStrLn

printInterpreterError :: InterpreterError -> IO ()
printInterpreterError e = putStrLn $ "Error Occured: " ++ (show e)
