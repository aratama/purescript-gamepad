module Main where

import Control.Bind (bind, discard)
import Data.Array (length, zipWith, (!!), (..), mapWithIndex)
import Data.Int (floor)
import Data.Maybe (Maybe(..))
import Data.Show (show)
import Data.Traversable (for_)
import Data.Tuple (Tuple(..))
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Console (log)
import Effect.Ref (new, read, write)
import Gamepad (Gamepad(..), GamepadButton(..), GamepadEventType(..), addGamepadEventListener, getGamepad, getGamepads)
import Prelude (not, otherwise, pure, unit, (&&), (*), (+), (<>))

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


            for_ gamepads case _ of 
                Nothing -> pure unit 
                Just (Gamepad gamepad) -> do 
                    for_ (mapWithIndex Tuple gamepad.buttons) \(Tuple index (GamepadButton button)) -> do 
                        setButtonState button.pressed index

                    let s = 40.0
                    for_ (mapWithIndex Tuple gamepad.axes) \(Tuple index value) -> case index of 
                        0 -> setButtonPosition "cx" (670 + floor (value * s)) 10 
                        1 -> setButtonPosition "cy" (408 + floor (value * s)) 10
                        2 -> setButtonPosition "cx" (1006 + floor (value * s)) 11
                        3 -> setButtonPosition "cy" (408 + floor (value * s)) 11
                        _ -> pure unit 


            rquestAnimationFrame update

    rquestAnimationFrame update


foreign import rquestAnimationFrame :: Effect Unit -> Effect Unit

foreign import setButtonState :: Boolean -> Int -> Effect Unit

foreign import setButtonPosition :: String -> Int -> Int -> Effect Unit