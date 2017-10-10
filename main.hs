{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE Strict, StrictData #-}

import Data.List
import Data.Maybe
import Data.Ord
import Data.Array.Unboxed
import Data.Array.ST
import Control.Monad
import Control.Monad.State.Lazy
import Control.Monad.ST
import qualified Data.ByteString.Char8 as B

data Point = Point { location :: (Int, Int)
                   , idx :: Int }

main = putStr . unlines . map (unwords . map show . sol) .
       evalState getTestcases . B.words =<< B.getContents
  where
  getInt = fst . fromJust . B.readInt <$> state (\(x:xs) -> (x, xs))
  getPoint i = do
    x <- getInt
    y <- getInt
    return $ Point (x, y) i
  getTestcase = do
    n <- getInt
    forM [1..n] getPoint
  getTestcases =
    getTestcase >>= \case
      [] -> return []
      tc -> (tc:) <$> getTestcases

sol :: [Point] -> [Int]
sol pts = elems $ runSTUArray $ do
  ans <- newArray (1, length pts) 0
  conquer (sortBy (comparing location) pts) ans
  return ans

conquer :: [Point] -> STUArray s Int Int -> ST s [Point]
conquer [] _ = return []
conquer [p] _ = return [p]
conquer pts ans = do
  l' <- conquer l ans
  r' <- conquer r ans
  merge l' r' 0 ans
  where
  (l, r) = splitAt (length pts `div` 2) pts
  merge xs [] _ _ = return xs
  merge [] ys acc ans = do
    forM_ ys $ \p -> addRank ans (idx p) acc
    return ys
  merge (x:xs) (y:ys) acc ans
    | (snd . location $ x) <= (snd . location $ y) =
        (x:) <$> merge xs (y:ys) (acc+1) ans
    | otherwise = do
        addRank ans (idx y) acc
        (y:) <$> merge (x:xs) ys acc ans
  addRank arr idx val = do
    newVal <- (val+) <$> readArray arr idx
    writeArray arr idx newVal

