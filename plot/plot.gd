extends Control
class_name Plot

@onready var _background = %Background
@onready var _center_marker: Marker2D = %Center
@onready var _line_container: Node2D = %LineContainer

@onready var x_axis: Line2D = %XAxis
@onready var y_axis: Line2D = %YAxis

const plot_colors: Array[Color] = [
	Color("f0971e"),
	Color("3e90f9"),
	Color("9972fd"),
	Color("ec4e8c"),
	Color("959ca6"),
]

var plot_origin: Vector2 = Vector2.ZERO
var plot_size: Vector2 = Vector2.ZERO

var plot_scale: Vector2 = Vector2(1, 0.01)

@export var origin_offset: Vector2 = Vector2(0.05, 0.9)

static var data_series: Dictionary[String, Array]

var is_ready = false
## Each element should be a list where:
##		First element: callable
##		Second element: list of arguments
var _pre_ready_queue: Array = []

## Returns a Plot object.
static func create_plot(data_name: String, _data: Array[Vector2]):
	data_series[data_name] = _data
	var plot_scene: PackedScene = load("res://plot/plot.tscn")
	return plot_scene.instantiate()


## Update the data values in a series.
func set_data(data_name: String, _data: Array[Vector2]):
	data_series[data_name] = _data
	update_data_lines()


## Add a horizontal axis to the canvas.
func add_haxis(y, color = Color("ffffff")):
	if not is_ready:
		_pre_ready_queue.append([add_haxis, [y, color]])
		return
	
	var line = Line2D.new()
	line.width = 2
	line.default_color = color
	_background.add_child(line)
	line.owner = _background
	
	line.points = [
		Vector2(0, plot_origin.y - y * plot_scale.y),
		Vector2(plot_size.x, plot_origin.y - y * plot_scale.y),
	]

func update_data_lines() -> void:
	for data_name in data_series.keys():
		var data: PackedVector2Array = PackedVector2Array(data_series[data_name])
		var line: Line2D = _line_container.find_child(data_name, false, false)
		
		# Dont do anything if there is no data
		if data.size() == 0:
			return
		
		if not line:
			line = Line2D.new()
			line.name = data_name
			line.width = 2
			line.default_color = plot_colors.pick_random()
			_line_container.add_child(line)
			line.owner = _line_container
		
		# Change scale to fit data on x-axis
		var max_x = data[-1].x
		var x_space = plot_size.x * (1 - origin_offset.x)
		if max_x * plot_scale.x > x_space:
			plot_scale.x = x_space / max_x
		
		# Scale data
		var scaled_data: PackedVector2Array = data
		for i in scaled_data.size():
			scaled_data[i] *= plot_scale
		
		line.points = scaled_data

func _ready() -> void:
	# Wait untill AFTER the first frame has been drawn
	await get_tree().process_frame
	await get_tree().process_frame
	
	var bkg_rect: Rect2 = _background.get_rect()
	
	plot_size = bkg_rect.size
	plot_origin = plot_size * origin_offset
	
	_center_marker.position = plot_origin
	
	# Set axis positions
	x_axis.points[0] = Vector2(0, origin_offset.y * plot_size.y)
	x_axis.points[1] = Vector2(plot_size.x, origin_offset.y * plot_size.y)
	y_axis.points[0] = Vector2(origin_offset.x * plot_size.x, 0)
	y_axis.points[1] = Vector2(origin_offset.x * plot_size.x, plot_size.y)
	
	update_data_lines()
	is_ready = true
	
	# Run queued canvas additions
	for task in _pre_ready_queue:
		task[0].callv(task[1])


func _on_plot_update_timer_timeout() -> void:
	update_data_lines()
