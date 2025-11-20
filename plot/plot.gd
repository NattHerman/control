extends Control
class_name Plot

@onready var _background: Panel = %Background
@onready var _center_marker: Marker2D = %Center

@onready var _data_line: Line2D = %DataLine
@onready var x_axis: Line2D = %XAxis
@onready var y_axis: Line2D = %YAxis


var plot_origin: Vector2 = Vector2.ZERO
var plot_size: Vector2 = Vector2.ZERO

static var data: Array[Vector2]

static func create_plot(_data: Array[Vector2]):
	data = _data
	var plot_scene: PackedScene = load("res://plot/plot.tscn")
	return plot_scene.instantiate()

func _ready() -> void:
	# Wait untill AFTER the first frame has been drawn
	await get_tree().process_frame
	await get_tree().process_frame
	
	plot_size = _background.get_global_rect().size
	
	_center_marker.global_position = _background.get_global_rect().position + plot_size * Vector2(0.1, 1) * 0.5
	plot_origin = _center_marker.global_position
	
	# Set axis positions
	x_axis.global_position = plot_origin
	y_axis.global_position = plot_origin
	x_axis.points[0] = plot_size.x * 0.95 * Vector2(1, 0)
	x_axis.points[1] = -plot_size.x * 0.05 * Vector2(1, 0)
	y_axis.points[0] = plot_size.y * 0.5 * Vector2(0, 1)
	y_axis.points[1] = -plot_size.y * 0.5 * Vector2(0, 1)
	
	_data_line.points = PackedVector2Array(data)
