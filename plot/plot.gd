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

@export var origin_offset: Vector2 = Vector2(0.05, 0.9)

static var data_series: Dictionary[String, Array]

static func create_plot(data_name: String, _data: Array[Vector2]):
	data_series[data_name] = _data
	var plot_scene: PackedScene = load("res://plot/plot.tscn")
	return plot_scene.instantiate()

func set_data(data_name: String, _data: Array[Vector2]):
	data_series[data_name] = _data
	
	update_data_lines()

func update_data_lines() -> void:
	for data_name in data_series.keys():
		var data: Array[Vector2] = data_series[data_name]
		var line: Line2D = _line_container.find_child(data_name, false, false)
		
		if not line:
			line = Line2D.new()
			line.name = data_name
			line.width = 2
			line.default_color = plot_colors.pick_random()
			line.owner = _line_container
			_line_container.add_child(line)
		
		line.points = PackedVector2Array(data)

func _ready() -> void:
	# Wait untill AFTER the first frame has been drawn
	await get_tree().process_frame
	await get_tree().process_frame
	
	var bkg_rect: Rect2 = _background.get_global_rect()
	
	plot_size = bkg_rect.size
	plot_origin = bkg_rect.position + plot_size * origin_offset
	
	_center_marker.global_position = plot_origin
	
	# Set axis positions
	#x_axis.global_position = plot_origin
	#y_axis.global_position = plot_origin
	x_axis.points[0] = Vector2(0, origin_offset.y * plot_size.y)
	x_axis.points[1] = Vector2(plot_size.x, origin_offset.y * plot_size.y)
	y_axis.points[0] = Vector2(origin_offset.x * plot_size.x, 0)
	y_axis.points[1] = Vector2(origin_offset.x * plot_size.x, plot_size.y)
	#x_axis.points[0] = plot_size.x * 0.5 * Vector2(1, 0)
	#x_axis.points[1] = -plot_size.x * 0.5 * Vector2(1, 0)
	#y_axis.points[0] = plot_size.y * 0.5 * Vector2(0, 1)
	#y_axis.points[1] = -plot_size.y * 0.5 * Vector2(0, 1)
	
	update_data_lines()


func _on_plot_update_timer_timeout() -> void:
	update_data_lines()
