extends Node

var plot: Plot

var thrust_ratio: float = 0.0
var error: float = 0
var speed: float = 0

var position_data := DataSeries.new("Height", 	[], Color(0.236, 0.71, 0.598, 1.0))
var angle_data := DataSeries.new("Angle", 	[], Color(0.609, 0.223, 0.755, 1.0), Vector2(1000, 44.76825))
var angle_ref_data := DataSeries.new("AngleRef", [], Color(0.953, 0.459, 0.0, 1.0), Vector2(1000, 2*PI*7.125))
