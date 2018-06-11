## Module Gamepad

#### `Gamepad`

``` purescript
newtype Gamepad
  = Gamepad { id :: String, index :: Int, connected :: Boolean, timeStamp :: Number, mapping :: GamepadMappingType, axes :: Array Number, buttons :: Array GamepadButton }
```

##### Instances
``` purescript
Eq Gamepad
```

#### `GamepadButton`

``` purescript
newtype GamepadButton
  = GamepadButton { pressed :: Boolean, touched :: Boolean, value :: Number }
```

##### Instances
``` purescript
Eq GamepadButton
```

#### `GamepadMappingType`

``` purescript
type GamepadMappingType = String
```

#### `GamepadEvent`

``` purescript
data GamepadEvent :: Type
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

#### `getGamepads`

``` purescript
getGamepads :: Effect (Array (Maybe Gamepad))
```

#### `addGamepadEventListener`

``` purescript
addGamepadEventListener :: GamepadEventType -> (GamepadEvent -> Effect Unit) -> Effect Unit
```

#### `getGamepad`

``` purescript
getGamepad :: GamepadEvent -> Gamepad
```


