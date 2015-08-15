{-# OPTIONS_GHC -fno-warn-unused-imports -fno-warn-orphans #-}
{-|
    Internal utilities and library imports.

>   Though here at journey's end I lie
>   in darkness buried deep,
>   beyond all towers strong and high,
>   beyond all mountains steep,
>   above all shadows rides the Sun
>   and Stars for ever dwell:
>   I will not say the Day is done,
>   nor bid the Stars farewell.
-}

module Pugs.Compat ( module X ) where

import Pugs.Compat.Cast       as X 
import Pugs.Compat.Global     as X 
import Pugs.Compat.ID         as X 
import Pugs.Compat.Monads     as X 
import Pugs.Compat.String     as X 
import Pugs.Compat.Posix      as X 
import Pugs.Compat.Regex      as X 

import Control.Concurrent     as X 
import Control.Concurrent.STM as X (TMVar, STM, atomically, always, alwaysSucceeds, retry, orElse, check, catchSTM)
import Control.Exception      as X (catchJust, Exception(..))
import Control.Monad          as X (replicateM, forM, forM_, MonadPlus(..), msum, liftM2, liftM3, guard, foldM, unless, liftM, filterM, join, when)
import Control.Monad.Error    as X (MonadError(..), ErrorT(..), Error(..))
import Control.Monad.Fix      as X (fix)
import Control.Monad.Identity as X (Identity(..))
import Control.Monad.Reader   as X (MonadReader(..), ReaderT(..), asks)
import Control.Monad.State    as X (MonadState(..), gets, modify)
import Control.Monad.Trans    as X (MonadIO(..), MonadTrans(..))
import Control.Monad.Writer   as X (MonadWriter(..), WriterT(..), censor)
import Data.Array             as X (elems)
import Data.Bits              as X hiding (shift)
import Data.ByteString        as X (ByteString)
import Data.Char              as X 
import Data.Complex           as X 
import Data.Dynamic           as X hiding (cast)
import Data.Either            as X 
import Data.Generics          as X (Data)
import Data.IORef             as X 
import Data.IntMap            as X (IntMap)
import Data.List              as X ( (\\), find, genericLength, insert, sortBy, intersperse, partition, group, sort, genericReplicate, isPrefixOf, isSuffixOf, genericTake, genericDrop, unfoldr, nub, nubBy, transpose, delete, foldl')
import Data.Map               as X (Map)
import Data.Maybe             as X 
import Data.Monoid            as X (Monoid(..))
import Data.Ratio             as X 
import Data.Sequence          as X (Seq, singleton)
import Data.Set               as X (Set)
import Data.Time              as X 
import Data.Time.Clock.POSIX  as X 
import Data.Tree              as X 
import Data.Unique            as X 
import Data.Word              as X hiding (Word)
import Debug.Trace            as X hiding (traceM)
import GHC.Conc               as X (unsafeIOToSTM)
import GHC.Exts               as X (unsafeCoerce#, Word(W#), Word#)
import Network                as X 
import Numeric                as X (showHex)
import System.Cmd             as X 
import System.Directory       as X (Permissions(..), getPermissions, getTemporaryDirectory, createDirectory, removeDirectory, removeFile, getDirectoryContents, getModificationTime)
import System.Environment     as X (getArgs, withArgs, getProgName)
import System.Exit            as X hiding (die)
import System.IO              as X ( Handle, stdin, stdout, hClose, hGetLine, hGetChar, hGetContents, openFile, hSetBinaryMode, hPutStr, hPutStrLn, IOMode(..), stderr, SeekMode(..), hSetBuffering, BufferMode(..), hIsTerminalDevice, hFlush, hPrint, isEOF, hSeek, hTell, hIsOpen, hIsClosed, hIsReadable, hIsWritable, hIsSeekable)
import System.IO.Error        as X (ioeGetErrorString, isUserError)
import System.IO.Unsafe       as X 
import System.Mem             as X 
import System.Mem.Weak        as X 
import System.Process         as X 
import System.Random          as X hiding (split)

import Text.Regex.Base        as X hiding (empty)
import Text.Regex.PCRE        as X hiding (empty)

-- Instances.
instance Show Unique where
    show = show . hashUnique
instance (Typeable a, Typeable b) => Show (a -> b) where
    show _ = "(" ++ typA ++ " -> " ++ typB ++ ")"
        where
        typA = show $ typeOf (undefined :: a)
        typB = show $ typeOf (undefined :: b)
instance (Typeable a, Typeable b) => Eq (a -> b) where
    x == y = show x == show y
instance (Typeable a, Typeable b) => Ord (a -> b) where
    compare x y = compare (show x) (show y)
instance Eq Dynamic where
    x == y = show x == show y
instance Ord Dynamic where
    compare x y = compare (show x) (show y)
