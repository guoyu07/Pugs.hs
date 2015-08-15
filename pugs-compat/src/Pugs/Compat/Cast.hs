{-# LANGUAGE BangPatterns #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
module Pugs.Compat.Cast (
    (:>:)(..),
    (:<:)(..),
    addressOf,
    showAddressOf,
    fromTypeable,
    _cast
) where

import GHC.Exts (unsafeCoerce#, Word(W#), Word#)
import Data.Dynamic hiding (cast)
import Data.ByteString (ByteString)
import Data.Sequence (Seq)
import Numeric (showHex)
import Data.Foldable (toList)
import qualified Data.Sequence as Seq
import qualified Data.Typeable as Typeable
import qualified Data.ByteString.UTF8 as UTF8

--
-- Nominal subtyping relationship with widening cast.
-- 
-- The function "cast" is injective: for distinct values of "b",
-- it must produce distinct values of "a".
--
-- Also, it must work for all values of type "b".
-- 
class ((:>:) a) b where
    cast :: b -> a

class ((:<:) a) b where
    castBack :: a -> b

instance (b :<: a) => (:>:) a b where
    cast = castBack

{-# INLINE _cast #-}
_cast :: (a :>: String) => String -> a
_cast = cast

instance (:<:) a a where castBack = id

instance ((:>:) [a]) (Seq a) where cast = toList
instance ((:<:) [a]) (Seq a) where castBack = Seq.fromList

-- "map cast" can be written as "cast"
instance (a :>: b) => ((:>:) [a]) [b] where cast = map cast

fromTypeable :: forall m a b. (Monad m, Typeable a, Typeable b) => a -> m b
fromTypeable x = case Typeable.cast x of
    Just y -> return y
    _      -> fail $ "Cannot cast from " ++ (show $ typeOf x) ++ " to " ++ (show $ typeOf (undefined :: b))

{-# INLINE addressOf #-}
addressOf :: a -> Word
addressOf !x = W# (unsafeCoerce# x)

{-# INLINE showAddressOf #-}
showAddressOf :: String -> a -> String
showAddressOf typ x = addr `seq` ('<' : typ ++ ":0x" ++ showHex addr ">")
    where
    addr = addressOf x

instance ((:>:) String) ByteString where
    cast = UTF8.toString
instance ((:<:) String) ByteString where
    castBack = UTF8.fromString

instance ((:<:) ByteString) String where
    castBack = UTF8.toString
