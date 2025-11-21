extends Node2D


var reference = 1000

@onready var rocket = %Rocket


@export_range(1, 20, 0.1) var time_scale: float = 1:
	set(value):
		time_scale = value
		Engine.time_scale = time_scale

func _ready() -> void:
	Engine.time_scale = time_scale
	reference = rocket.reference
	$ReferenceMarker.position.y = -reference
