class_name LockedTowerSlot
extends Control

var slot

@onready var unlock_cost_label: Label = $Panel/VBoxContainer2/HBoxContainer2/Label2
@onready var unlock_currency_label: Label = $Panel/VBoxContainer2/HBoxContainer3/Label2
@onready var unlock_button: Button = $Panel/VBoxContainer2/HBoxContainer5/Button
@onready var close_button: Button = $Panel/VBoxContainer2/HBoxContainer4/Button

func _ready() -> void:
	unlock_button.pressed.connect(unlock)
	close_button.pressed.connect(close)

func open(slot_: TowerSlot) -> void:
	slot = slot_
	unlock_cost_label.text = str(slot.unlock_cost)
	unlock_currency_label.text = slot.unlock_currency
	var screen_centre = get_viewport().get_visible_rect().size / 2
	var offset_x = -50 if slot_.global_position.x > screen_centre.x else 50
	var offset_y = -50 if slot_.global_position.y > screen_centre.y else 50
	global_position = slot_.global_position + Vector2(offset_x, offset_y)
	show()
	
func close() -> void:
	hide()
	
func unlock() -> void:
	slot.unlock_slot()
	close()
