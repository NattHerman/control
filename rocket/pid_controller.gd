extends RefCounted
class_name PIDController

var Kp: float = 0
var Ki: float = 0
var Kd: float = 0

var _prev_error: float = 0
var _integral_error: float = 0


func set_PID(P: float, I: float, D: float) -> void:
	Kp = P
	Ki = I
	Kd = D

## This function should run every physics frame, so that
## the error integral and derivative stays accurate.
func control(error, dt) -> float:
	# Trapezoidal sum type integral
	_integral_error += ((error + _prev_error)/ 2) * dt
	
	# This is not the best numerical derivative, i know.
	var error_derivative = (error - _prev_error) * dt
	
	_prev_error = error
	
	# The control function
	var  u = Kp * error + Ki * _integral_error + Kd + error_derivative
	return u
