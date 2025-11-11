extends Node2D

@onready var camera_rig = $".."
@onready var camera_utils = $"../CameraUtils"

func _draw():
	if not camera_rig or not camera_utils:
		push_warning("Missing camera or utils")
		return
		
	var wp_size = get_viewport().size
	var screen_center = wp_size / 2

	var near_size = camera_utils.rate_to_pixel(camera_rig.near_radius)
	draw_circle(screen_center, near_size, Color.RED, false)

	var far_size = camera_utils.rate_to_pixel(camera_rig.far_radius)
	draw_circle(screen_center, far_size, Color.RED, false)

@warning_ignore("unused_parameter")
func _process(delta):
	# Request redraw every frame
	queue_redraw()
