
import Data.List
import Data.Ord

data Point = Point { location :: (Int, Int)
                   , index :: Int
                   , rank :: Int }
   deriving Show

main = interact $ unlines . map (unwords . map show . sol) .
                  splitTestcase . map read . words

splitTestcase :: [Int] -> [[Point]]
splitTestcase (0:xs) = []
splitTestcase (x:xs) = pack now 0 : splitTestcase next
  where
  (now, next) = splitAt (x*2) xs
  pack [] _ = []
  pack (x:y:xs) i = Point (x, y) i 0 : pack xs (i+1)

sol :: [Point] -> [Int]
sol = map rank . postSort . conquer . preSort
  where
  preSort = sortBy $ comparing location
  postSort = sortBy $ comparing index

conquer :: [Point] -> [Point]
conquer [] = []
conquer [p] = [p]
conquer ps = (\(l, r) -> merge (conquer l) (conquer r) 0) . divide $ ps
  where
  divide xs = splitAt (length xs `div` 2) xs
  merge xs [] _ = xs
  merge [] ys acc = map (\p -> p { rank = rank p + acc}) ys
  merge (x:xs) (y:ys) acc
    | (snd . location $ x) <= (snd . location $ y) = x : merge xs (y:ys) (acc+1)
    | otherwise =  y { rank = rank y + acc } : merge (x:xs) ys acc

