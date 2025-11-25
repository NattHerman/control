extends RigidBody2D
## A drone where its x and y positions are regulated using PID-controllers.


var y_controller := PIDController.new()
var x_controller := PIDController.new()
var angle_controller := PIDController.new()

var reference_position: Vector2 = Vector2(0, -100)
var reference_angle: float = PI/2

var gravity: float = 981
var world_gravity: float = 981
var r: float = 1.0

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
	r = absf(right_thruster.position.x)
	
	y_controller.PD_critically_dampened(mass)
	angle_controller.PD_critically_dampened(mass*r)
	angle_controller.Kp *= 6
	
	await get_tree().process_frame
	gravity = get_gravity().length()
	
	var Gs = 2
	left_thruster.max_thrust = mass * world_gravity * Gs
	right_thruster.max_thrust = mass * world_gravity * Gs


func _physics_process(delta: float) -> void:
	var height: float = position.y
	var yerror: float = reference_position.y - height
	ui_values.error = roundf(yerror)
	
	var yu_pid: float = y_controller.control(yerror, delta)
	var yu_nom: float = -gravity * mass
	
	var yu: float = yu_pid + yu_nom
	
	var angle_error: float = reference_angle - global_rotation
	
	if angle_error < -PI:
		angle_error += 2*PI
	elif angle_error > PI:
		angle_error -= 2*PI
	
	#var angle_error_other_way: float
	#if global_rotation < reference_angle:
		#angle_error_other_way = angle_error - 360
	#elif global_rotation > reference_angle:
		#angle_error_other_way = angle_error + 360
	#
	#print(abs(angle_error_other_way) < abs(angle_error))
	#if abs(angle_error_other_way) < abs(angle_error):
		#angle_error = angle_error_other_way
	
	var angle_u_pid = angle_controller.control(angle_error, delta)
	
	left_thruster.set_thrust(angle_u_pid / 2)
	right_thruster.set_thrust(-angle_u_pid / 2)
	
	#left_thruster.set_thrust(-yu/2)
	#right_thruster.set_thrust(-yu/2)
	
	ui_values.speed = linear_velocity.length()
	if Time.get_ticks_msec() % 10 == 0:
		ui_values.angle_data.append(Vector2(
			global_timer.time,
			rotation
		))
		ui_values.angle_ref_data.append(Vector2(
			global_timer.time,
			reference_angle
		))
		ui_values.position_data.append(Vector2(
			global_timer.time,
			position.y
		))
