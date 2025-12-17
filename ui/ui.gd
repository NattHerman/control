extends Control

@onready var thrust_ratio_bar = %ThrustRatioBar
@onready var error_label = %ErrorLabel
@onready var speed_label = %SpeedLabel
@onready var plot: Plot = %Plot


func _process(_delta: float) -> void:
	thrust_ratio_bar.value = ui_values.thrust_ratio
	error_label.text = "Error: " + str(round(ui_values.error))
	speed_label.text = "Speed: " + str(round(ui_values.speed))


func _ready() -> void:
	plot.set_data(ui_values.x_position_data)
	plot.set_data(ui_values.x_reference_data)
	plot.set_data(ui_values.y_position_data)
	plot.set_data(ui_values.y_reference_data)
	
	#plot.set_data(ui_values.angle_ref_data)
	#plot.set_data(ui_values.angle_data)
	#plot.add_haxis(1280*3, Color("#ffcc6b"))
	#plot.add_vaxis(100, Color("#ffcc6b") * 0.5)
	plot.visible = %TogglePlot.button_pressed
	%ManualModeToggle.button_pressed = ui_values.manual_mode


func _on_toggle_plot_toggled(toggled_on: bool) -> void:
	plot.visible = toggled_on


func _on_manual_mode_toggle_toggled(toggled_on: bool) -> void:
	ui_values.manual_mode = toggled_on
