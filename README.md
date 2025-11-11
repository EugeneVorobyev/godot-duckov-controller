# godot-duckov-controller
3D character and camera controller like in Escape from Duckov for Godot

## Intoduction
This is a simple example of character and camera controller that has features like in the
game Escape from Duckov but also extend it a little bit, so should be considered as more 
like generic 3D top-down isometric controller for action games.

## Features
There are few main features in this example:
	
### Character movement and rotation
First of all it has basic character WASD movement and rotation to cursor components

#### Following camera
Setup for independent camera to follow the character and potentially for cut scenes

#### Following (shift) cursor
Setup to shift camera towards the cursor to provide more action oriented feeling

## Technical decisions
There are few technical decision that were intentionally made and maybe different from other examples and tutorials

1. Camera is not a descendant of character component. It's very simple to apply position transition from one side but allow flexibility for more complex scenarions down the road like cut scenes.

2. Using tweens for transitions instead of manual lerp calculations. Unless it's a clear bottlneck for your project, using tweens provides much more advantages in readability and simplicity.
