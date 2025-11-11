class_name Player
extends CharacterBody3D

## Player move speed
@export var move_speed: float = 5.0

## Rotation ease speed
@export var ease_speed: float = 5.0

## Camera rig
@onready var camera_rig = $CameraRig

func _physics_process(delta: float) -> void:
	_handle_movement()
	_handle_rotation(delta)

## Handle player movement
func _handle_movement() -> void:
	var input_dir = InputManager.get_input_direction()
	var velocity_vector = input_dir * move_speed
	velocity.x = velocity_vector.x
	velocity.z = velocity_vector.z
	move_and_slide()

## Handle player rotation
func _handle_rotation(delta: float) -> void:
	if not camera_rig:
		printerr("Missing camera")
		return
	
	var camera: Camera3D = camera_rig.camera
	var viewport = get_viewport();
	if not viewport:
		printerr("Missing viewport")
		return
		
	var mouse_pos = viewport.get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var dir = camera.project_ray_normal(mouse_pos)
	var plane = Plane(Vector3.UP, position.y)
	var mouse_world_pos = plane.intersects_ray(from, dir)

	if mouse_world_pos != null:
		var target_dir = (position - mouse_world_pos).normalized()
		var target_rot_y = atan2(target_dir.x, target_dir.z)
		var current_rot_y = rotation.y
		rotation.y = lerp_angle(current_rot_y, target_rot_y, 1.0 - pow(0.001, delta * ease_speed))
