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
	
	var mouse_ground_pos = MouseManager.get_mouse_pos_at_node_level(self)
	if mouse_ground_pos != null:
		var target_dir = (position - mouse_ground_pos).normalized()
		var target_rot_y = atan2(target_dir.x, target_dir.z)
		var current_rot_y = rotation.y
		rotation.y = lerp_angle(current_rot_y, target_rot_y, 1.0 - pow(0.001, delta * ease_speed))
