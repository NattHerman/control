extends RigidBody2D
## A drone where its x and y positions are regulated using PID-controllers.


var y_controller := PIDController.new()
var x_controller := PIDController.new()

var reference: Vector2 = Vector2(0, -100)

var gravity: float = 981

@onready var left_thruster = %LeftPropeller
@onready var right_thruster = %RightPropeller

@export var y_PID_parameters: Vector3 = Vector3.ZERO:
	set(value):
		y_controller.Kp = value.x
		y_controller.Ki = value.y
		y_controller.Kd = value.z
	get:
		return Vector3(y_controller.Kp, y_controller.Ki, y_controller.Kd)

@export var x_PID_parameters: Vector3 = Vector3.ZERO:
	set(value):
		x_controller.Kp = value.x
		x_controller.Ki = value.y
		x_controller.Kd = value.z
	get:
		return Vector3(x_controller.Kp, x_controller.Ki, x_controller.Kd)

func _ready() -> void:
	y_controller.PD_critically_dampened(mass)
	
	var Gs = 2
	left_thruster.max_thrust = mass * gravity * Gs
	right_thruster.max_thrust = mass * gravity * Gs


func _physics_process(delta: float) -> void:
	var height: float = position.y
	var yerror: float = reference.y - height
	ui_values.error = roundf(yerror)
	
	var u_pid: float = y_controller.control(yerror, delta)
	var u_nom: float = -gravity * mass
	
	var u: float = u_pid + u_nom
	
	left_thruster.set_thrust(-u/2)
	right_thruster.set_thrust(-u/2)
	
	ui_values.speed = linear_velocity.length()
	if Time.get_ticks_msec() % 10 == 0:
		ui_values.positon_list.append(Vector2(
			global_timer.time,
			position.y
		))
