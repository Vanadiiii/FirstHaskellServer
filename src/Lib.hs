module Lib (server) where

import Network.Socket
import Network.Socket.ByteString
import Control.Concurrent (forkIO)
import qualified Data.ByteString.Char8 as B8
import System.Environment (getArgs)

server :: PortNumber -> IO ()
server port = withSocketsDo $ do
                sock <- socket AF_INET Stream defaultProtocol
                bind sock (SockAddrInet port 0)
-- Слушаем сокет. 
-- Максимальное кол-во клиентов для подключения - 5.
                listen sock 5
-- Запускаем наш Socket Handler.
                sockHandler sock                 
                close sock

sockHandler :: Socket -> IO ()
sockHandler sock = do
-- Принимаем входящее подключение.
  (sockh, _) <- accept sock
-- В отдельном потоке получаем сообщения от клиента.
  forkIO $ putStrLn "Client connected!" >> receiveMessage sockh
  sockHandler sock

receiveMessage :: Socket -> IO ()
receiveMessage sockh = do
  msg <- recv sockh 10 -- Получаем только 10 байт.
  B8.putStrLn msg -- Выводим их.
-- Если сообщение было пусто или оно равно "q" (quit)
  if msg == B8.pack "q" || B8.null msg
-- Закрываем соединение с клиентом.
  then close sockh >> putStrLn "Client disconnected"
  else receiveMessage sockh -- Или получаем следующее сообщение.
