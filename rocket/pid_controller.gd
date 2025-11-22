extends RefCounted
class_name PIDController


var Kp: float = 0
var Ki: float = 0
var Kd: float = 0
var Kb: float = 1

var _prev_error: float = 0
var _integral_error: float = 0
var _prev_delta_u = 0
var _integral_delta_u: float = 0

var back_propagation := false
var sat_min: float = 0
var sat_max: float = 1

func set_PID(P: float, I: float, D: float, B: float = 1) -> void:
	Kp = P
	Ki = I
	Kd = D
	Kb = B

func set_back_propogation(enabled: bool, _sat_min: float = 0, _sat_max = 1):
	back_propagation = enabled
	sat_min = _sat_min
	sat_max = _sat_max

## This function should run every physics frame, so that
## the error integral and derivative stays accurate.
func control(error: float, dt: float) -> float:
	# Trapezoidal sum type integral
	_integral_error += ((error + _prev_error)/ 2) * dt
	
	# This is not the best numerical derivative, i know.
	var error_derivative = (error - _prev_error) / dt
	print(error_derivative)
	
	_prev_error = error
	
	# The control function
	var u = Kp * error + Ki * _integral_error + Kd * error_derivative 
	if back_propagation:
		u += _integral_delta_u * Kb
	
	var saturated_u = clampf(u, sat_min, sat_max)
	var _delta_u = saturated_u - u
	
	if back_propagation:
		_integral_delta_u += ((_delta_u + _prev_delta_u)/ 2) * dt
	_prev_delta_u = _delta_u
	
	return u
