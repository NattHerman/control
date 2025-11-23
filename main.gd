extends Node2D


var reference:
	get:
		return target.reference
	set(value):
		target.reference = value

@onready var target = $Drone

@export_range(1, 20, 0.01)
var time_scale: float = 1:
	set(value):
		time_scale = value
		Engine.time_scale = time_scale


func _ready() -> void:
	Engine.time_scale = time_scale
	if reference is Vector2:
		$ReferenceLine.position.y = reference.y
	else:
		$ReferenceLine.position.y = reference

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and (event.button_index == MouseButton.MOUSE_BUTTON_LEFT):
		var centerscreen_mouse_pos = (get_viewport().get_mouse_position()  - get_viewport_rect().size * 0.5)
		reference = centerscreen_mouse_pos / %Camera2D.zoom + %Camera2D.global_position
		$ReferenceMarker.reference = reference
		$ReferenceLine.position.y = reference.y
