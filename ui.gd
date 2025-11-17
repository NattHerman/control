extends Control

@onready var thrust_ratio_bar = %ThrustRatioBar
@onready var error_label = %ErrorLabel

func _process(_delta: float) -> void:
	thrust_ratio_bar.value = ui_values.thrust_ratio
	error_label.text = str(ui_values.error)
