extends Control

@onready var close_button: Button = $Panel/VBoxContainer2/HBoxContainer4/Button


func _ready() -> void:
	close_button.pressed.connect(close)
	close()
func open() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	global_position = (screen_size / 2) - (size / 2)
	show()

func close() -> void:
	hide()
