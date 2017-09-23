module UI.Event (Event(..)) where

data Event =  Next
            | Previous
            | Restart
            | Content String
            | RequestContent
            | Noop
