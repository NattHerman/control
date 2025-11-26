extends Node2D


var reference_pos:
	get:
		return target.reference_position
	set(value):
		target.reference_position = value

var ref_angle:
	get:
		return target.reference_angle
	set(value):
		target.reference_angle = value

@onready var target = $Drone

@export_range(1, 20, 0.01)
var time_scale: float = 1:
	set(value):
		time_scale = value
		Engine.time_scale = time_scale


func _ready() -> void:
	Engine.time_scale = time_scale
	if reference_pos is Vector2:
		$ReferenceLine.position.y = reference_pos.y
	else:
		$ReferenceLine.position.y = reference_pos

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and (event.button_index == MouseButton.MOUSE_BUTTON_LEFT):
		var centerscreen_mouse_pos = (get_viewport().get_mouse_position()  - get_viewport_rect().size * 0.5)
		var global_mouse_pos = centerscreen_mouse_pos / %Camera2D.zoom + %Camera2D.global_position
		reference_pos = global_mouse_pos
		$ReferenceMarker.reference = reference_pos
		$ReferenceLine.position.y = reference_pos.y
		var target_to_mouse = global_mouse_pos - target.position
		ref_angle = atan2(-target_to_mouse.x, target_to_mouse.y)

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
		var centerscreen_mouse_pos = (get_viewport().get_mouse_position()  - get_viewport_rect().size * 0.5)
		var global_mouse_pos = centerscreen_mouse_pos / %Camera2D.zoom + %Camera2D.global_position
		reference_pos = global_mouse_pos
		$ReferenceMarker.reference = reference_pos
		$ReferenceLine.position.y = reference_pos.y
		var target_to_mouse = global_mouse_pos - target.position
		ref_angle = atan2(-target_to_mouse.x, target_to_mouse.y)
