class_name LevelUI
extends Control

@onready var level: Level = get_node("/root/Level")
@onready var economy: Economy = get_node("/root/Level/Economy")

# Currency Labels
@onready var spikes_label: Label = $Panel/HBoxContainer/HBoxContainer2/Panel/VBoxContainer/HBoxContainer/Label2         
@onready var splotches_label: Label = $Panel/HBoxContainer/HBoxContainer2/Panel2/VBoxContainer/HBoxContainer/Label2       
@onready var spirals_label: Label = $Panel/HBoxContainer/HBoxContainer2/Panel3/VBoxContainer/HBoxContainer/Label2      
# Info Labels
@onready var lives_label: Label = $Panel/HBoxContainer/HBoxContainer2/Panel4/VBoxContainer/HBoxContainer/Label2            
@onready var wave_label: Label = $Panel/HBoxContainer/HBoxContainer3/Panel3/VBoxContainer/HBoxContainer/Label
@onready var wave_label_total: Label = $Panel/HBoxContainer/HBoxContainer3/Panel3/VBoxContainer/HBoxContainer/Label4   


# Buttons
@onready var start_wave_button: Button = $Panel/HBoxContainer/HBoxContainer3/Button5
@onready var pause_button: Button = $Panel/HBoxContainer/HBoxContainer/Button2
@onready var speed_1x_button: Button = $Panel/HBoxContainer/HBoxContainer/Button3
@onready var speed_2x_button: Button = $Panel/HBoxContainer/HBoxContainer/Button4       
@onready var settings_button: Button = $Panel/HBoxContainer/HBoxContainer3/Button

@onready var settings_ui = get_node("/root/Level/ui/Control")

func _ready() -> void:
	start_wave_button.pressed.connect(_on_start_wave_pressed)
	pause_button.pressed.connect(_on_pause_pressed)
	speed_1x_button.pressed.connect(_on_speed_1x_pressed)
	speed_2x_button.pressed.connect(_on_speed_2x_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	economy.value_updated.connect(_on_economy_updated)
	level.info_updated.connect(_on_info_updated)
	_on_economy_updated()
	_on_info_updated()

func _on_start_wave_pressed() -> void:
	level.start_wave()

func _on_pause_pressed() -> void:
	Engine.time_scale = 0

func _on_speed_1x_pressed() -> void:
	Engine.time_scale = 1

func _on_speed_2x_pressed() -> void:
	Engine.time_scale = 2

func _on_settings_pressed() -> void:
	settings_ui.open()

func _on_economy_updated() -> void:
	spikes_label.text = str(economy.spikes)
	splotches_label.text = str(economy.splotches)
	spirals_label.text = str(economy.spirals)

func _on_info_updated() -> void:
	lives_label.text = str(level.lives)
	wave_label.text = str(level.current_wave)
	wave_label_total.text = str(level.total_waves)
