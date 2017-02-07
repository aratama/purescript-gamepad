module Main where

import Control.Bind (bind, when)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Ref (REF, newRef, readRef, writeRef)
import Data.Array (length, zipWith, (!!), (..))
import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Show (show)
import Data.Traversable (for_)
import Data.Tuple (Tuple(..))
import Data.Unit (Unit)
import Gamepad (GAMEPAD, Gamepad(..), GamepadButton(..), GamepadEventType(..), addGamepadEventListener, getGamepad, getGamepads)
import Prelude (pure, unit, (<>), (>>=), (/=), (&&), not, otherwise)

main :: forall eff. Eff (gamepad :: GAMEPAD, ref :: REF, console :: CONSOLE | eff) Unit
main = do

    ref <- newRef []

    addGamepadEventListener GamepadConnected \e -> do
        Gamepad gamepad <- pure (getGamepad e)
        log ("Gamepad connected: " <> gamepad.id)

    addGamepadEventListener GamepadDisconnected \e -> do
        Gamepad gamepad <- pure (getGamepad e)
        log ("Gamepad disconnected: " <> gamepad.id)

    let update = do
            gamepads <- getGamepads
            gamepads' <- readRef ref
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
            writeRef ref gamepads
            rquestAnimationFrame update

    rquestAnimationFrame update


foreign import rquestAnimationFrame :: forall eff. Eff eff Unit -> Eff eff Unit
