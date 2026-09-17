extends Control

@onready var play_button: Button = $Panel/VBoxContainer2/HBoxContainer5/Button
@onready var settings_button: Button = $Panel/VBoxContainer2/HBoxContainer6/Button
@onready var exit_button: Button = $Panel/VBoxContainer2/HBoxContainer8/Button

@onready var settings = $"Node/Control"

func _ready() -> void:
	play_button.pressed.connect(func():
		AudioManager.play_sfx("button_press")
		_play()
	)
	
	
	
	settings_button.pressed.connect(func():
		AudioManager.play_sfx("button_press")
		_settings()
	)

	exit_button.pressed.connect(func():
		AudioManager.play_sfx("button_press")
		_exit()
	)

func _play() -> void:
	get_tree().change_scene_to_file("res://level/level1.tscn")

func _settings() -> void:
	settings.open()

func _exit() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
