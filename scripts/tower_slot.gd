class_name TowerSlot
extends Node2D

@export var current_tower: Tower
@export var unlocked: bool = true
@export var unlock_cost: int = 0
@export var unlock_currency: String = "spikes"
@onready var economy: Economy = get_node("/root/Level/Economy")

@onready var locked_sprite: Sprite2D = $locked_sprite
@onready var unlocked_sprite: Sprite2D = $unlocked_sprite

@onready var filled_slot_ui: FilledSlot = get_node("/root/Level/ui/filledSlot")
@onready var empty_slot_ui: EmptyMenu = get_node("/root/Level/ui/emptySlot")
@onready var locked_slot_ui: LockedTowerSlot = get_node("/root/Level/ui/lockedSlot")



func _ready() -> void:
	locked_sprite.visible = !unlocked 
	unlocked_sprite.visible = unlocked
	$Area2D.input_event.connect(_input_event)
	empty_slot_ui.hide()
	filled_slot_ui.hide()
	locked_slot_ui.hide()

func _input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		empty_slot_ui.close()
		filled_slot_ui.close()
		locked_slot_ui.close()
		if !unlocked:
			locked_slot_ui.open(self)
		elif current_tower != null:
			filled_slot_ui.open(self)
		else:
			empty_slot_ui.open(self)  
			
	
func unlock_slot() -> void:
	if unlocked:
		return
	if economy.can_afford(unlock_currency, unlock_cost):
		economy.reduce_currency(unlock_currency, unlock_cost)
		unlocked = true
		locked_sprite.visible = false
		unlocked_sprite.visible = true

func place_tower(tower_scene: PackedScene) -> void:
	if !unlocked or current_tower != null:
		return
	var tower: Tower = tower_scene.instantiate()
	if !economy.can_afford(tower.tower_type, tower.cost):
		tower.queue_free()
		return
	empty_slot_ui.close()
	economy.reduce_currency(tower.tower_type, tower.cost)
	get_parent().add_child(tower)
	tower.place(self)
	current_tower = tower
	
