@tool
extends RigidBody2D


var pid_controller := PIDController.new()
var reference: float = 1280*3

var drag_coefficient = 10 # going off vibes
var gravity = 980

@onready var main_thruster = $MainThruster

@export_category("Height PID-Controller")
@export var Kp: float = 0.0:
	set(value):
		Kp = value
		pid_controller.Kp = value

@export var Ki: float = 0.0:
	set(value):
		Ki = value
		pid_controller.Ki = value

@export var Kd: float = 0.0:
	set(value):
		Kd = value
		pid_controller.Kd = value


func _ready() -> void:
	var omega0: float = 2*PI * 1
	Kp = (omega0 ** 2) * mass
	Kd = 2 * omega0 * mass
	
	pid_controller.set_PID(Kp, Ki, Kd)
	pid_controller.set_back_propogation(false, 0, main_thruster.max_thrust)
	
	var thrust_Gs: float = 3
	
	main_thruster.max_thrust = mass * gravity * thrust_Gs


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		var height: float = -position.y
		var error: float = reference - height
		ui_values.error = roundf(error)
		
		var u_pid: float = pid_controller.control(error, delta)
		var u_nom: float = gravity * mass
		
		var u: float = u_pid + u_nom
		print(round(u_pid), " ", round(u_nom))
		
		main_thruster.set_thrust(u)
		
		var drag = linear_velocity.length_squared() * drag_coefficient
		#print(round(linear_velocity.length_squared()),"; " , drag_coefficient)
		apply_force(-linear_velocity.normalized() * drag)
		
		ui_values.speed = linear_velocity.length()
		ui_values.positon_list.append(Vector2(
			Time.get_ticks_msec() * 0.001 * Engine.time_scale,
			position.y * 0.01
		))
