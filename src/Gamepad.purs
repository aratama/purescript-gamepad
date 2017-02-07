module Gamepad (
    GAMEPAD, Gamepad(Gamepad), GamepadButton(GamepadButton), GamepadMappingType, GamepadEvent, GamepadEventType(..),
    getGamepads, addGamepadEventListener, getGamepad 
) where

import Control.Monad.Eff (Eff)
import Data.Eq (class Eq)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Data.Show (class Show, show)
import Data.Unit (Unit)
import Prelude (map, (<$>))

foreign import data GAMEPAD :: !

newtype GamepadButton = GamepadButton {
    pressed :: Boolean,
    touched :: Boolean,
    value :: Number
}

derive instance eqGamepadButton :: Eq GamepadButton

newtype Gamepad = Gamepad {
    id :: String,
    index :: Int,
    connected :: Boolean,
    timeStamp :: Number,
    mapping :: GamepadMappingType,
    axes :: Array Number,
    buttons :: Array GamepadButton
}

derive instance eqGamepad :: Eq Gamepad

type GamepadMappingType = String

foreign import _getGamepads :: forall eff. Eff (gamepad :: GAMEPAD | eff) (Array (Nullable Gamepad))

getGamepads :: forall eff. Eff (gamepad :: GAMEPAD | eff) (Array (Maybe Gamepad))
getGamepads = map toMaybe <$> _getGamepads

foreign import data GamepadEvent :: *

foreign import getGamepad :: GamepadEvent -> Gamepad

data GamepadEventType = GamepadConnected | GamepadDisconnected

instance showGamepadEventType :: Show GamepadEventType where
    show GamepadConnected = "gamepadconnected"
    show GamepadDisconnected = "gamepaddisconnected"

foreign import _addGamepadEventListener :: forall eff. String -> (GamepadEvent -> Eff (gamepad :: GAMEPAD | eff) Unit) -> Eff (gamepad :: GAMEPAD | eff) Unit

addGamepadEventListener :: forall eff. GamepadEventType -> (GamepadEvent -> Eff (gamepad :: GAMEPAD | eff) Unit) -> Eff (gamepad :: GAMEPAD | eff) Unit
addGamepadEventListener eventType = _addGamepadEventListener (show eventType)

