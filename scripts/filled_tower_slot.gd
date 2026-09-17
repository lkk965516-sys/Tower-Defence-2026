class_name FilledSlot
extends Control

var tower: Tower
var slot: TowerSlot

@onready var texture_rect_tower: TextureRect = $Panel/VBoxContainer2/HBoxContainer6/Panel/CenterContainer/TextureRect
@onready var texture_rect_slot: TextureRect = $Panel/VBoxContainer2/HBoxContainer6/Panel/CenterContainer/TextureRect2

@onready var tower_name: Label = $Panel/VBoxContainer2/HBoxContainer/name
@onready var tower_damage: Label = $Panel/VBoxContainer2/HBoxContainer6/VBoxContainer/HBoxContainer/Label2
@onready var tower_attack_speed: Label = $Panel/VBoxContainer2/HBoxContainer6/VBoxContainer/HBoxContainer2/Label2
@onready var tower_range: Label = $Panel/VBoxContainer2/HBoxContainer6/VBoxContainer/HBoxContainer3/Label2
@onready var tower_kills: Label = $Panel/VBoxContainer2/HBoxContainer5/Label2
@onready var tower_aim: Label = $Panel/VBoxContainer2/HBoxContainer2/Label
@onready var tower_cost_upgrade: Label = $Panel/VBoxContainer2/HBoxContainer7/Label2

@onready var upgrade_button: Button = $Panel/VBoxContainer2/HBoxContainer3/Button2
@onready var sell_button: Button = $Panel/VBoxContainer2/HBoxContainer3/Button
@onready var back_button: Button = $Panel/VBoxContainer2/HBoxContainer2/Button
@onready var forward_button: Button = $Panel/VBoxContainer2/HBoxContainer2/Button2
@onready var close_button: Button = $Panel/VBoxContainer2/HBoxContainer4/Button

@onready var economy: Economy = get_node("/root/Level/Economy")
var range_indicator: Node2D

func  _ready() -> void:
	upgrade_button.pressed.connect(upgrade)
	sell_button.pressed.connect(sell)
	back_button.pressed.connect(change_backward_targeting)
	forward_button.pressed.connect(change_forward_targeting)
	close_button.pressed.connect(close)
	
	
func open(slot_: TowerSlot) -> void:
	slot = slot_
	tower = slot.current_tower
	
	tower_name.text = tower.tower_name
	tower_damage.text = str(tower.damage)
	tower_attack_speed.text = str(tower.attack_speed)
	tower_range.text = str(tower.range)
	tower_kills.text = str(tower.enemies_killed)
	tower_aim.text = str(tower.target_priority)
	texture_rect_tower.texture = tower.get_node("Sprite2D").texture
	
	if tower.current_level >= tower.max_level or tower.upgrade_cost[tower.current_level] == -1:
		tower_cost_upgrade.text = "Max Level"
	else:
		tower_cost_upgrade.text = str(tower.upgrade_cost[tower.current_level])
	
	var screen_centre = get_viewport().get_visible_rect().size / 2
	var offset_x = -380 if slot_.global_position.x > screen_centre.x else 50
	var offset_y = -410 if slot_.global_position.y > screen_centre.y else 50
	global_position = slot_.global_position + Vector2(offset_x, offset_y)
	
	range_indicator = AOEEffect.new()
	get_tree().current_scene.add_child(range_indicator)
	range_indicator.global_position = slot.global_position
	range_indicator.setup(slot.current_tower.range)
	range_indicator.queue_redraw()
	
	show()

func close() -> void:
	if range_indicator:
		range_indicator.queue_free()
		range_indicator = null
	hide()

func sell() -> void:
	slot.current_tower = null
	var tower_type = tower.tower_type
	var sell_price = tower.sell()
	economy.add_currency(tower_type, sell_price)
	close()

func upgrade() -> void:
	if tower.current_level >= tower.max_level or tower.upgrade_cost[tower.current_level] == -1:
		return
	if !economy.can_afford(tower.tower_type, tower.upgrade_cost[tower.current_level]):
		return
	economy.reduce_currency(tower.tower_type, tower.upgrade())
	close()
	open(slot)

func change_forward_targeting() -> void:
	tower.change_target_forward()
	tower_aim.text = tower.target_priority
	
func change_backward_targeting() -> void:
	tower.change_target_backward()
	tower_aim.text = tower.target_priority
