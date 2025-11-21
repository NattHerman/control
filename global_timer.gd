extends Timer

var time_int: int = 0
var time: float:
	get:
		return time_int + time_left

func _ready() -> void:
	autostart = true
	connect("timeout", increment_time)

func increment_time():
	time_int += 1
