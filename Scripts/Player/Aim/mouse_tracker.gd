extends Node3D
class_name MouseTracker

## Active player
@export var player: Player

## Keep the last reported distance
var _distance: float = 0.0

## Report a distance from player to aim
signal distance_changed(distance)

@warning_ignore("unused_parameter")
func _process(delta):
	if not player:
		return
	_calculate_distance()
	
## Calculates and report new distance from player to aim
func _calculate_distance():
	var mouse_ground_pos := MouseManager.get_mouse_pos_at_node_level(player)
	
	var distance = (player.position - mouse_ground_pos).length()
	if is_equal_approx(_distance, distance):
		return
		
	_distance = distance
	distance_changed.emit(_distance)
