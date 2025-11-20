extends RigidBody2D

@export_category("Height PID-Controller")
@export var Kp: float = 0.0
@export var Ki: float = 0.0
@export var Kd: float = 0.0

var pid_controller := PIDController.new()
var reference: float = 1280*3

var drag_coefficient = 0.5 # going off vibes

@onready var main_thruster = $MainThruster


func _ready() -> void:
	pid_controller.set_PID(Kp, Ki, Kd)
	pid_controller.set_back_propogation(true, 0, main_thruster.max_thrust)
	
	var thrust_Gs: float = 3
	
	main_thruster.max_thrust = mass * 9.8 * thrust_Gs


func _physics_process(delta: float) -> void:
	var height = -position.y
	var error = reference - height
	ui_values.error = roundf(error)
	
	var u = pid_controller.control(error, delta)
	
	main_thruster.set_thrust(u)
	
	var drag = linear_velocity.length_squared() * drag_coefficient
	apply_force(-linear_velocity.normalized() * drag)
	
	ui_values.speed = linear_velocity.length()
	ui_values.positon_list.append(Vector2(
		Time.get_ticks_msec() * 0.001 * Engine.time_scale,
		position.y * 0.01
	))
