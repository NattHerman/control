extends RigidBody2D

@export_category("Height PID-Controller")
@export var Kp: float = 0.0
@export var Ki: float = 0.0
@export var Kd: float = 0.0

var pid_controller = PIDController.new()

var reference: float = 1000

@onready var main_thruster = $MainThruster


func _ready() -> void:
	pid_controller.set_PID(Kp, Ki, Kd)
	
	var thrust_Gs: float = 3
	
	main_thruster.max_thrust = mass * 9.8 * thrust_Gs


func _physics_process(delta: float) -> void:
	var height = -position.y
	var error = reference - height
	ui_values.error = roundf(error)
	
	var u = pid_controller.control(error, delta)
	
	main_thruster.set_thrust(u)
