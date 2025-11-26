extends Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var vec = DrawVector.new(Vector2.ONE * 100, Vector2.ZERO)
		add_child(vec)
