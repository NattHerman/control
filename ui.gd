extends Control

@onready var thrust_ratio_bar = %ThrustRatioBar
@onready var error_label = %ErrorLabel
@onready var speed_label = %SpeedLabel
@onready var plot: Plot = %Plot

var start_child_count: int = 0


func _process(_delta: float) -> void:
	thrust_ratio_bar.value = ui_values.thrust_ratio
	error_label.text = "Error: " + str(round(ui_values.error))
	speed_label.text = "Speed: " + str(round(ui_values.speed))
	
	start_child_count = $VBoxContainer.get_child_count()

func _ready() -> void:
	plot.set_data("Height", ui_values.positon_list)
