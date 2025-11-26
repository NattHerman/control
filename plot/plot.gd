extends Control
class_name Plot
## A tool for plotting [code]DataSeries[/code]


@onready var _background: Panel = %Background
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

#var plot_scale: Vector2 = Vector2(50, 100)
var plot_scale: Vector2 = Vector2(10000, 1)
var max_point_count: int = 300

@export var origin_offset: Vector2 = Vector2(0.05, 0.5)

static var data_series_dict: Dictionary[String, DataSeries]

var is_ready = false
## Each element in queue should be an array where:
##		First element: callable
##		Second element: array of arguments
var _pre_ready_queue: Array = []


## Returns a Plot object.
static func create_plot(data_series: DataSeries):
	assert(data_series.name != "", "data_series name cannot be empty.")
	data_series_dict[data_series.name] = data_series
	var plot_scene: PackedScene = load("res://plot/plot.tscn")
	return plot_scene.instantiate()


## Update the data value reference for a series.
func set_data(data_series: DataSeries):
	assert(data_series.name != "", "data_series name cannot be empty.")
	data_series_dict[data_series.name] = data_series


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


## Add a vertical axis to the canvas.
func add_vaxis(x, color = Color("ffffff")):
	if not is_ready:
		_pre_ready_queue.append([add_vaxis, [x, color]])
		return
	
	var line = Line2D.new()
	line.width = 2
	line.default_color = color
	_background.add_child(line)
	line.owner = _background
	
	line.points = [
		Vector2(plot_origin.x + x * plot_scale.x, 0),
		Vector2(plot_origin.x + x * plot_scale.x, plot_size.y),
	]


func update_data_lines() -> void:
	for data_name in data_series_dict.keys():
		var data_series: DataSeries = data_series_dict[data_name]
		var data: PackedVector2Array = data_series.data
		var line: Line2D = _line_container.find_child(data_name, false, false)
		
		# Skip if there is no data
		if data.size() == 0:
			continue
		
		if not line:
			line = Line2D.new()
			line.name = data_name
			line.width = 2
			line.default_color = data_series.color
			_line_container.add_child(line)
			line.owner = _line_container
		
		# Change scale to fit data on x-axis
		var x_space = plot_size.x * (1 - origin_offset.x)
		if data_series.max_x * data_series.scale.x > x_space:
			data_series.scale.x = x_space / abs(data_series.max_x)
		
		# Change scale to fit data on y-axis
		var y_space = plot_size.y * (1 - origin_offset.y)
		if (data_series.max_y * data_series.scale.y) > y_space or (abs(data_series.min_y) * data_series.scale.y) > y_space:
			data_series.scale.y = y_space / max(abs(data_series.max_y),abs(data_series.min_y))
		
		line.points = data_series.get_scaled()

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
