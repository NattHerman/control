extends RefCounted
class_name DataSeries
## A datastructure to contain data for plotting. [br][/b]
## Has a [param name] and contains a set of [param data] values.[b]


var name: StringName = ""
var color: Color

var data: PackedVector2Array = []

var max_y: float = 0
var min_y: float = 0

var max_x: float = 0
var min_x: float = 0

var scale: Vector2 = Vector2(10000, 10000)


func _init(
		_name: StringName,
		_data: PackedVector2Array,
		_color: Color = Color(0.681, 0.668, 0.944, 1.0),
		_scale: Vector2 = Vector2(10000, 10000),
	) -> void:
	name = _name
	data = _data
	color = _color
	scale = _scale


func _to_string() -> String:
	return "DataSeries(" + name + ", " + str(data) + ")"


func append_with_time(value: float):
	append(Vector2(global_timer.time, value))


func append(point: Vector2):
	data.append(point)
	
	if point.x > max_x:
		max_x = point.x
	elif point.x < min_x:
		min_x = point.x
	if point.y > max_y:
		max_y = point.y
	elif point.y < min_y:
		min_y = point.y


func append_array(data_points: PackedVector2Array):
	data.append_array(data_points)
	
	for point in data_points:
		if point.x > max_x:
			max_x = point.x
		elif point.x < min_x:
			min_x = point.x
		if point.y > max_y:
			max_y = point.y
		elif point.y < min_y:
			min_y = point.y


func get_scaled():
	var scaled_data: PackedVector2Array = data.duplicate()
	
	for i in scaled_data.size():
		scaled_data[i] *= scale
	
	return scaled_data
