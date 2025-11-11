class_name CameraRig
extends Node3D

## The shifting part of the camera rig
## that is moving toward cursor
@onready var offset_rig = $OffsetRig
## Active camera
@onready var camera = $OffsetRig/Camera3D
## Camera debug overlay
@onready var camera_debug = $CameraDebug
## Camera utils
@onready var utils = $CameraUtils

## Camera target to focus on
@export var player: Player
## Enable following to the target
@export var enabled: bool = false	
## Enable camera cursor shift
@export var enable_cursor_shift: bool = false

@export_group("Camera to cursor")
## Near radius from which the shift starts to work
## Measured in viewport width rate units (similar to vw in CSS)
@export_range(0, 100)
var near_radius: int = 10
## Shift power at the minimal radius
@export var near_shift = 0.5

## Far radius where shift reaches maximum power
## Measured in viewport width rate units (similar to vw in CSS)
@export_range(0, 100)
var far_radius: int = 30
## Shift power at the maximum radius
@export var far_shift = 6.0

@export_group("Camera follow")
## Camera follow duration time in seconds
## Smaller the duration, faster the camera follow speed
@export var follow_duration: float = 0.2

## Hold the base camera offset from the target
var _offset = Vector3.ZERO
## Hold the current pointer to the tween object, to kill it on update
var _tween: Tween
## Hold the value of lookahead shift to cursor
var _lookahead: Vector3 = Vector3.ZERO

## Calculare the base camera offset from the target
func _calc_offset():
	if not player:
		printerr("Player is no assigned")
		return	
	var offset_x = global_position.x - player.position.x
	var offset_z = global_position.z - player.position.z
	_offset = Vector3(offset_x, 0, offset_z)

func _ready():
	_calc_offset()

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if not player || not enabled:
		return

	# Pass 1: take player position + base camera offset
	# This is no ease movement
	var base_pos := global_position
	base_pos.x = player.global_position.x + _offset.x
	base_pos.z = player.global_position.z + _offset.z
	base_pos.y = global_position.y
	
	# Pass 2: add lookahead component
	# lookahead is tweened into target position making smooth shift
	var final_pos = base_pos
	if enable_cursor_shift:
		final_pos = base_pos + _lookahead
	
	global_position = final_pos
	
	# Recalculate lookahead value for the next iteration
	var target_shift = _add_cursor_offset()
	calculate_lookahead(target_shift)

## Calculate smooth shift toward lookahead position
func calculate_lookahead(target: Vector3):
	if _lookahead.is_equal_approx(target):
		return

	if _tween and _tween.is_running():
		_tween.kill()
		
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_QUAD)
	_tween.set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "_lookahead", target, 0.5)

## Returns a new position considering shift to cursor
func _add_cursor_offset() -> Vector3:
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	var center_pos = viewport.get_visible_rect().size / 2

	#
	# Calculate direction vector from center of screen to cursor
	# and convert it to the viewport width rate (to make it work on all resolutions)
	#
	var offset_vector = mouse_pos - center_pos
	var offset_rate = utils.pixel_to_rate(round(offset_vector.length()))
	
	#
	# Map a value from shift radius range to a shift power range
	#
	var shift = remap(offset_rate, near_radius, far_radius, near_shift, far_shift)

	#
	# Clamp lower value and fix the maximum value
	# translate into vector space to calculate final shift
	#
	var step_shift = step(shift, near_shift, far_shift) 
	var shift_vector = step_shift * offset_vector.normalized();
	return Vector3(shift_vector.x, 0, shift_vector.y)

func step(value, min_value, max_value):
	if value < min_value:
		return 0
	if value > max_value:
		return max_value
	return value
