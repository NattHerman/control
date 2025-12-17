extends Line2D
class_name DrawVector


var lifespan: float = 1


func _init(_vector: Vector2, pos: Vector2, _lifespan: float = 0.5) -> void:
	points = [Vector2.ZERO, _vector]
	global_position = pos
	lifespan = _lifespan
	
	width = 3
	end_cap_mode = Line2D.LINE_CAP_ROUND
	
	debug_draw.main_node.add_child(self)


func _ready() -> void:
	var timer: SceneTreeTimer = get_tree().create_timer(lifespan)
	timer.connect("timeout", queue_free)
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	queue_free()
