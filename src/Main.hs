{-# LANGUAGE OverloadedStrings #-}
--import Something
--import Commands
import Control.Monad
import Language.Haskell.Interpreter
import Turtle
import Options.Applicative
import Control.Applicative

main :: IO ()
main = execParser opts >>= decompose
  where
    opts = info (helper <*> options)
      ( fullDesc
     <> progDesc "Print a greeting for TARGET"
     <> header "hello - a test for optparse-applicative" ) 


decompose :: Options -> IO ()
decompose (Options (Just h) False m) = putStrLn $ "Hello, " ++ h
decompose (Options Nothing False m) = putStrLn $ "Optional string missing"
decompose _ = do
  echo "List help here..."
  r <- runInterpreter testHint
  case r of
    Left err -> printInterpreterError err
    Right () -> putStrLn "that's all folks"
--decompose _ = return ()
--main = do                           --
--    echo "Line 1"                   -- echo Line 1
--    echo "Line 2"                   -- echo Line 2


data Options = Options
  { hello :: Maybe String
  , quiet :: Bool
  , more :: String }

-- equivalent to: optional . strOption
optionalStrOption :: Mod OptionFields String -> Parser (Maybe String)
optionalStrOption flags = Just <$> strOption flags <|> pure Nothing

options :: Parser Options
options = Options
--     <$> strOption
     <$> optionalStrOption
         ( long "hello"
        <> metavar "TARGET"
        <> help "Target for the greeting" )
     <*> switch
         ( long "quiet"
        <> help "Whether to be quiet" )
     <*> strOption
         ( long "more"
        <> metavar "TARGET"
        <> help "Target for the more" )

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
