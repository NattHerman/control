extends Node2D


var reference = 1000

@onready var rocket = %Rocket

func _ready() -> void:
	Engine.time_scale = 10
	reference = rocket.reference
	$ReferenceMarker.position.y = -reference
