{-# LANGUAGE OverloadedStrings #-}
module UmuHalogen.Capability.ManageCommand
  ( genProj
  , ManageCommand (..)
  ) where

import qualified Data.Text        as T
import qualified Data.Text.IO     as TIO
import           Import
import           System.Directory (createDirectory)
import           UmuHalogen.Util

class Monad m => ManageCommand m where
  generateProject :: Maybe Text -> m ()

instance ManageCommand IO where
  generateProject = liftIO . generateProject

genProj :: MonadIO m => Maybe Text -> m ()
genProj mLoc = do
  writeSrcDir mLoc
  writeSpagoFile mLoc
  writePackagesFile mLoc
  writeHTMLDir mLoc
  writeIndexHTML mLoc

writeSrcDir :: MonadIO m => Maybe Text -> m ()
writeSrcDir mLoc = do
  liftIO $ createDirectory ( T.unpack $ mkPathName mLoc "src" )
  message $ "Generating src..."

writeSpagoFile :: MonadIO m => Maybe Text -> m ()
writeSpagoFile mLoc = do
  spagoFile <- liftIO $ TIO.readFile "./templates/spago.dhall"
  liftIO $ TIO.writeFile ( T.unpack $ mkPathName mLoc "spago.dhall" ) spagoFile
  message $ "Generating spago.dhall..."

writePackagesFile :: MonadIO m => Maybe Text -> m ()
writePackagesFile mLoc = do
  packagesFile <- liftIO $ TIO.readFile "./templates/packages.dhall"
  liftIO $ TIO.writeFile ( T.unpack $ mkPathName mLoc "packages.dhall") packagesFile
  message $ "Generating packages.dhall..."

writeHTMLDir :: MonadIO m => Maybe Text -> m ()
writeHTMLDir mLoc = do
  liftIO $ createDirectory ( T.unpack $ mkPathName mLoc "html" )
  message $ "Generating html..."

writeIndexHTML :: MonadIO m => Maybe Text -> m ()
writeIndexHTML mLoc = do
  indexHtmlFile <- liftIO $ TIO.readFile "./templates/index.html"
  liftIO $ TIO.writeFile ( T.unpack $ mkPathName mLoc "/html/index.html" ) indexHtmlFile
  message $ "Generating index.html..."

mkPathName :: Maybe Text -> Text -> Text
mkPathName mLoc fileName =
  maybe "./" (\loc -> "./" <> loc <> "/") mLoc <> fileName
