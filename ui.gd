extends Control

@onready var thrust_ratio_bar = %ThrustRatioBar
@onready var error_label = %ErrorLabel
@onready var speed_label = %SpeedLabel

var start_child_count: int = 0


func _process(_delta: float) -> void:
	thrust_ratio_bar.value = ui_values.thrust_ratio
	error_label.text = "Error: " + str(round(ui_values.error))
	speed_label.text = "Speed: " + str(round(ui_values.speed))
	
	start_child_count = $VBoxContainer.get_child_count()


func _on_plot_button_pressed() -> void:
	var existing_plot: Node = $VBoxContainer.find_child("Plot", false, false)
	
	if existing_plot:
		existing_plot.queue_free()
		await existing_plot.child_exiting_tree
	
	var plot = Plot.create_plot(ui_values.positon_list)
	plot.name = "Plot"
	$VBoxContainer.add_child.call_deferred(plot)
