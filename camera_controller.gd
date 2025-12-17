extends Camera2D


var speed: float = 256*2
var speed_modification: float = 2
@export var panning_enabled = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom *= 1.1
	elif event.is_action_pressed("zoom_out"):
		zoom *= 0.9
	
	zoom.x = max(zoom.x, 1)
	zoom.y = max(zoom.y, 1)


func _process(delta: float) -> void:
	if not panning_enabled:
		return
	
	var movement_direction = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	var velocity = movement_direction * speed / zoom.x
	
	if (Input.is_action_pressed("pan_speed_increase")):
		velocity *= speed_modification
	
	position += velocity * delta / Engine.time_scale
