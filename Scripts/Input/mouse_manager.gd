class_name MouseManager
extends RefCounted

## Calculate the mouse position on the Y level of the provided [code]Node3D[/code]
## based on mouse cursor position, current viewport and camera
static func get_mouse_pos_at_node_level(node: Node3D) -> Vector3:
	if not node:
		push_error("Undefined node provided")
		return Vector3.ZERO
	
	var viewport := node.get_viewport()
	if not viewport:
		push_error("Missing viewport")
		return Vector3.ZERO

	var camera := viewport.get_camera_3d()
	if not camera:
		push_error("Missing camera reference in player")
		return Vector3.ZERO
		
	var mouse_pos = viewport.get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var dir = camera.project_ray_normal(mouse_pos)
	var plane = Plane(Vector3.UP, node.position.y)
	return plane.intersects_ray(from, dir)
