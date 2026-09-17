class_name Economy
extends Node

@export_category("Currency")
@export var spikes: int = 90
@export var splotches: int = 90
@export var spirals: int = 90

@export_category("Capacity")
@export var spikes_capacity: int = 999
@export var splotches_capacity: int = 999
@export var spirals_capacity: int = 999

@export_category("Tower Count")
@export var spikes_towers: int = 0
@export var splotches_towers: int = 0
@export var spirals_towers: int = 0

signal value_updated

func add_tower(tower: String) -> void:
	if tower == "spikes":
		spikes_towers += 1
		value_updated.emit()
		return
	if tower == "splotches":
		splotches_towers += 1
		value_updated.emit()
		return
	if tower == "spirals":
		spirals_towers += 1
		value_updated.emit()
		return
		

func remove_tower(tower: String) -> void:
	if tower == "spikes":
		spikes_towers -= 1
		return
	if tower == "splotches":
		splotches_towers -= 1
		return
	if tower == "spirals":
		spirals_towers -= 1
		return

func add_currency(tower: String, value: int) -> void:
	if tower == "spirals":
		spikes += value
		if spikes > spikes_capacity:
			spikes = spikes_capacity
		value_updated.emit()
		return
		
	if tower == "spikes":
		splotches += value
		if splotches > splotches_capacity:
			splotches = splotches_capacity
		value_updated.emit()
		return
		
	if tower == "splotches":
		spirals += value * 2
		if spirals > spirals_capacity:
			spirals = spirals_capacity
		value_updated.emit()
		return
		
		

func  reduce_currency(tower: String, value: int) -> void:
	if tower == "spikes":
		spikes = max(0, spikes - value)
		value_updated.emit()
		return
		
	if tower == "splotches":
		splotches = max(0, splotches - value)
		value_updated.emit()
		return
		
	if tower == "spirals":
		spirals = max(0, spirals - value)
		value_updated.emit()
		return

func can_afford(tower: String, value: int) -> bool:
	if tower == "spikes":
		if spikes < value:
			return false
		return true
		
	if tower == "splotches":
		if splotches < value:
			return false
		return true
		
	if tower == "spirals":
		if spirals < value:
			return false
		return true
	return false
	
	
	
func get_wave_bonus(value: int) -> void:
	if spikes_towers <= splotches_towers:
		if spikes_towers <= spirals_towers:
			add_currency("spikes", value)
			
			return
		else:
			add_currency("spirals", value)
			
			return
	else:
		if splotches_towers <= spirals_towers:
			add_currency("splotches", value)
			
			return
		
		else:
			add_currency("spirals", value)
			
			return
