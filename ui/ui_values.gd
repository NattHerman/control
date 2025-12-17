extends Node

var plot: Plot

var thrust_ratio: float = 0.0
var error: float = 0
var speed: float = 0

var big_scale := Vector2(1000, 100)

var y_position_data := DataSeries.new("Y", [], Color(0.236, 0.71, 0.598, 1.0))
var y_reference_data := DataSeries.new("YRef", [], Color(0.343, 0.521, 0.468, 1.0))
var x_position_data := DataSeries.new("X", [], Color(0.795, 0.299, 0.257, 1.0), big_scale, true)
var x_reference_data := DataSeries.new("XRef", [], Color(0.541, 0.217, 0.141, 1.0), big_scale, true)

var angle_data := DataSeries.new("Angle", [], Color(0.609, 0.223, 0.755, 1.0), Vector2(1000, 44.76825))
var angle_ref_data := DataSeries.new("AngleRef", [], Color(0.953, 0.459, 0.0, 1.0), Vector2(1000, 2*PI*7.125))

var manual_mode: bool = false
