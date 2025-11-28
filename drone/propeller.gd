extends CollisionShape2D


var target_thrust: float = 0 # Force [N]
var current_thrust: float = 0: # Force [N]
	set(value):
		current_thrust = clampf(value, -max_thrust, max_thrust)

var max_thrust: float = 0


func set_thrust(thrust: float) -> void:
	current_thrust = clampf(thrust, -max_thrust, max_thrust)


func _process(_delta: float) -> void:
	var thrust_ratio = current_thrust / max_thrust
	$ExhaustParticles.amount_ratio = thrust_ratio
	ui_values.thrust_ratio = thrust_ratio


func _physics_process(_delta: float) -> void:
	var up = -global_transform.y
	get_parent().apply_force(up * current_thrust)
	DrawVector.new(up * current_thrust * 0.01, get_parent().global_position, 0.01)
