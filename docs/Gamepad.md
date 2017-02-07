## Module Gamepad

#### `GAMEPAD`

``` purescript
data GAMEPAD :: Effect
```

#### `GamepadButton`

``` purescript
newtype GamepadButton
  = GamepadButton { "pressed" :: Boolean, "touched" :: Boolean, "value" :: Number }
```

##### Instances
``` purescript
Eq GamepadButton
```

#### `Gamepad`

``` purescript
newtype Gamepad
  = Gamepad { "id" :: String, "index" :: Int, "connected" :: Boolean, "timeStamp" :: Number, "mapping" :: GamepadMappingType, "axes" :: Array Number, "buttons" :: Array GamepadButton }
```

##### Instances
``` purescript
Eq Gamepad
```

#### `GamepadMappingType`

``` purescript
type GamepadMappingType = String
```

#### `getGamepads`

``` purescript
getGamepads :: forall eff. Eff ("gamepad" :: GAMEPAD | eff) (Array (Maybe Gamepad))
```

#### `GamepadEvent`

``` purescript
data GamepadEvent :: Type
```

#### `getGamepad`

``` purescript
getGamepad :: GamepadEvent -> Gamepad
```

#### `GamepadEventType`

``` purescript
data GamepadEventType
  = GamepadConnected
  | GamepadDisconnected
```

##### Instances
``` purescript
Show GamepadEventType
```

#### `addGamepadEventListener`

``` purescript
addGamepadEventListener :: forall eff. GamepadEventType -> (GamepadEvent -> Eff ("gamepad" :: GAMEPAD | eff) Unit) -> Eff ("gamepad" :: GAMEPAD | eff) Unit
```


