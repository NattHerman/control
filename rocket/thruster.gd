extends CollisionShape2D


var target_thrust: float = 0 # Force [N]
var current_thrust: float = 0 # Force [N]

var max_thrust: float = 78.48e3 * 10


func set_thrust(thrust: float) -> void:
	#target_thrust = thrust
	#current_thrust = target_thrust
	current_thrust = clampf(thrust, 0, max_thrust)


func _process(_delta: float) -> void:
	var thrust_ratio = current_thrust / max_thrust
	$ExhaustParticles.amount_ratio = thrust_ratio
	ui_values.thrust_ratio = thrust_ratio


func _physics_process(_delta: float) -> void:
	var down = -global_transform.y
	get_parent().apply_force(down * current_thrust, global_position)
	#print(round(current_thrust), " ", round(current_thrust / max_thrust))
