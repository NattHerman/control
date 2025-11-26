extends RigidBody2D
## A drone where its x and y positions are regulated using PID-controllers.


var y_controller := PIDController.new()
var x_controller := PIDController.new()
var angle_controller := PIDController.new()

var reference_position: Vector2 = Vector2(0, -100)
var reference_angle: float = 0

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
	x_controller.PD_critically_dampened(mass)
	angle_controller.PD_critically_dampened(mass*r)
	angle_controller.Kp *= 6
	angle_controller.Kd *= 15
	
	await get_tree().process_frame
	gravity = get_gravity().length()
	
	var Gs = 6
	left_thruster.max_thrust = mass * world_gravity * Gs
	right_thruster.max_thrust = mass * world_gravity * Gs


func _physics_process(delta: float) -> void:
	var yerror: float = reference_position.y - position.y
	
	var yu_pid: float = y_controller.control(yerror, delta)
	var yu_nom: float = -gravity * mass
	
	var yu: float = yu_pid + yu_nom
	
	var xerror: float = reference_position.x - position.x
	var xu: float = x_controller.control(xerror, delta)
	
	#reference_angle = atan2(xu, -yu)
	var lean_dir = Input.get_axis("lean_left", "lean_right")
	reference_angle = lean_dir * PI/6
	
	var angle_error: float = reference_angle - global_rotation
	
	if angle_error < -PI:
		angle_error += 2*PI
	elif angle_error > PI:
		angle_error -= 2*PI
	
	var angle_u_pid = angle_controller.control(angle_error, delta)
	
	left_thruster.current_thrust = angle_u_pid / 2
	right_thruster.current_thrust = -angle_u_pid / 2
	
	#yu = yu_nom
	#yu = yu / (cos(global_rotation) * 2)
	
	left_thruster.current_thrust = -yu
	right_thruster.current_thrust = -yu
	#left_thruster.current_thrust += -u / 2
	#right_thruster.current_thrust += -u / 2
	#left_thruster.set_thrust(-yu/2)
	#right_thruster.set_thrust(-yu/2)
	
	ui_values.speed = linear_velocity.length()
	if Time.get_ticks_msec() % 10 == 0:
		ui_values.angle_data.append_with_time(rotation)
		ui_values.angle_ref_data.append_with_time(reference_angle)
		ui_values.position_data.append_with_time(global_position.y)
