module Main where

import Control.Bind (bind, discard)
import Data.Array (length, zipWith, (!!), (..))
import Data.Maybe (Maybe(..))
import Data.Show (show)
import Data.Traversable (for_)
import Data.Tuple (Tuple(..))
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Console (log)
import Effect.Ref (new, read, write)
import Gamepad (Gamepad(..), GamepadButton(..), GamepadEventType(..), addGamepadEventListener, getGamepad, getGamepads)
import Prelude (not, otherwise, pure, unit, (&&), (<>))

main :: Effect Unit
main = do

    ref <- new []

    addGamepadEventListener GamepadConnected \e -> do
        Gamepad gamepad <- pure (getGamepad e)
        log ("Gamepad connected: " <> gamepad.id)

    addGamepadEventListener GamepadDisconnected \e -> do
        Gamepad gamepad <- pure (getGamepad e)
        log ("Gamepad disconnected: " <> gamepad.id)

    let update = do
            gamepads <- getGamepads
            gamepads' <- read ref
            for_ (zipWith Tuple gamepads gamepads') case _ of
                Tuple (Just (Gamepad x)) (Just (Gamepad y)) -> do
                    let buttons = zipWith Tuple x.buttons y.buttons
                    for_ (0 .. length buttons) \i -> case buttons !! i of
                        Just (Tuple (GamepadButton a) (GamepadButton b)) | a.pressed && not b.pressed -> do
                                            log ("button " <> show i <> " pressed")
                                         | not a.pressed && b.pressed -> do
                                            log ("button " <> show i <> " released")
                                         | otherwise -> do
                                            pure unit
                        _ -> pure unit
                _ -> pure unit
            write gamepads ref 
            rquestAnimationFrame update

    rquestAnimationFrame update


foreign import rquestAnimationFrame :: Effect Unit -> Effect Unit
