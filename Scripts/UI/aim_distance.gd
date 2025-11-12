extends Label

## Translation from engine units to in-game units
## TODO: make object proper sizes to avoid using factors
const distance_factor = 3

func _on_mouse_tracker_distance_changed(distance):
	var in_game_distance = distance / distance_factor
	text = "%.1f" % in_game_distance
