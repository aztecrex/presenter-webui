module Interop where

import Prelude (bind, pure, show, ($), (<<<))
import Data.Either (Either(..), either)
import Data.Maybe (Maybe(..))
import Control.Monad.Aff (attempt, Aff)
import Network.HTTP.Affjax (AJAX, get)
import Data.Argonaut (class DecodeJson, decodeJson, (.?))


type Todos = Array Todo

newtype Todo = Todo
  { id :: Int
  , title :: String }

data Event = RequestTodos | ReceiveTodos (Either String Todos)

instance decodeJsonTodo :: DecodeJson Todo where
  decodeJson json = do
    obj <- decodeJson json
    id <- obj .? "id"
    title <- obj .? "title"
    pure $ Todo { id: id, title: title }

getSomething :: forall r.
      Aff
        ( ajax :: AJAX
        | r
        )
        (Maybe Event)
getSomething =  do
      res <- attempt $ get "http://jsonplaceholder.typicode.com/users/1/todos"
      let decode r = decodeJson r.response :: Either String Todos
      let todos = either (Left <<< show) decode res
      pure $ Just $ ReceiveTodos todos
