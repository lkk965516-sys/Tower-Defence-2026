class_name TowerButton
extends Control
@onready var texture_rect: TextureRect = $VBoxContainer/Panel/CenterContainer/TextureRect
@onready var label: Label = $VBoxContainer/HBoxContainer/Label2
@onready var label2: Label = $VBoxContainer/HBoxContainer/Label
@onready var button: Button = $VBoxContainer/Panel/Button

func setup(tower_scene: PackedScene, slot: TowerSlot) -> void:
	var tower = tower_scene.instantiate()
	texture_rect.texture = tower.icon
	label.text = str(tower.cost)
	button.text = str(tower.tower_name)
	button.pressed.connect(func(): 
		slot.place_tower(tower_scene)
	)
	tower.queue_free()
