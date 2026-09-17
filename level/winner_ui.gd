class_name WINNERUI
extends Control

@onready var continue_button: Button = $Panel/VBoxContainer2/HBoxContainer5/Button
@onready var restart_button: Button = $Panel/VBoxContainer2/HBoxContainer6/Button
@onready var menu_button: Button = $Panel/VBoxContainer2/HBoxContainer7/Button
@onready var exit_button: Button = $Panel/VBoxContainer2/HBoxContainer8/Button

@onready var live_label: Label = $Panel/VBoxContainer2/VBoxContainer/HBoxContainer3/Label

func _ready() -> void:
	continue_button.pressed.connect(func():
		AudioManager.play_sfx("button_press")
		_continue()
	)
	restart_button.pressed.connect(func():
		AudioManager.play_sfx("button_press")
		_restart()
	)
	menu_button.pressed.connect(func():
		AudioManager.play_sfx("button_press")
		_menu()
	)
	exit_button.pressed.connect(func():
		AudioManager.play_sfx("button_press")
		_exit()
	)
	
	
	
func open(lives_: int) -> void:
	live_label.text = str(lives_)
	show()
	
func close() -> void:
	hide()

func _continue() -> void:
	get_tree().change_scene_to_file("res://level/main_menu.tscn")

func _restart() -> void:
	get_tree().reload_current_scene() 	

func _menu() -> void:	
	get_tree().change_scene_to_file("res://level/main_menu.tscn")

func _exit() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
