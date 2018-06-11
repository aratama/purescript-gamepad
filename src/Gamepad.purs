module Gamepad (
    Gamepad(Gamepad), GamepadButton(GamepadButton), GamepadMappingType, GamepadEvent, GamepadEventType(..),
    getGamepads, addGamepadEventListener, getGamepad 
) where

import Effect (Effect)
import Data.Eq (class Eq)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Data.Show (class Show, show)
import Data.Unit (Unit)
import Prelude (map, (<$>))

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

foreign import _getGamepads :: Effect (Array (Nullable Gamepad))

getGamepads :: Effect (Array (Maybe Gamepad))
getGamepads = map toMaybe <$> _getGamepads

foreign import data GamepadEvent :: Type

foreign import getGamepad :: GamepadEvent -> Gamepad

data GamepadEventType = GamepadConnected | GamepadDisconnected

instance showGamepadEventType :: Show GamepadEventType where
    show GamepadConnected = "gamepadconnected"
    show GamepadDisconnected = "gamepaddisconnected"

foreign import _addGamepadEventListener :: String -> (GamepadEvent -> Effect Unit) -> Effect Unit

addGamepadEventListener :: GamepadEventType -> (GamepadEvent -> Effect Unit) -> Effect Unit
addGamepadEventListener eventType = _addGamepadEventListener (show eventType)

