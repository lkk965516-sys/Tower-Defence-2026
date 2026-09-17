class_name EmptyMenu
extends Control

@export var available_towers: Array[PackedScene] = [
	preload("res://level/towers/spiker.tscn"),
	preload("res://level/towers/splotcher.tscn"),
	preload("res://level/towers/spiraler.tscn")
]
var tower_button_scene: PackedScene = preload("res://level/tower_button.tscn")

@onready var grid_container: GridContainer = $Panel/VBoxContainer2/GridContainer
@onready var close_button: Button = $Panel/VBoxContainer2/HBoxContainer4/Button

var current_slot: TowerSlot
var slot_size: int = 50

func _ready() -> void:
	
	close_button.pressed.connect(close)
	
func open(slot: TowerSlot) -> void:
	current_slot = slot
	global_position = slot.global_position + Vector2(slot_size, 0)
	populate()
	var screen_centre = get_viewport().get_visible_rect().size / 2
	var offset_x = -380 if slot.global_position.x > screen_centre.x else 50
	var offset_y = -530 if slot.global_position.y > screen_centre.y else 50
	global_position = slot.global_position + Vector2(offset_x, offset_y)
	show()
	

func close() -> void:
	current_slot = null
	for child in grid_container.get_children():
		child.queue_free()
	hide()

	
func populate() -> void:
	for tower_scene in available_towers:
		var button = tower_button_scene.instantiate()
		grid_container.add_child(button)
		button.setup(tower_scene, current_slot)
	
