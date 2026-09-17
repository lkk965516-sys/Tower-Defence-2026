class_name  WaveManager
extends Node

enum STATE {SPAWNING, WAITING}
signal level_cleared
signal wave_ended

var state = STATE.WAITING
var wave_data = []
var current_index: int = 0
var enemies_alive:int = 0
var complete: bool = false

@onready var enemy_node: Node = get_node("/root/Level/Enemies")

func setup(data: Array):
	wave_data = data

func process_next():
	while current_index < wave_data.size():
		var index = wave_data[current_index]
		current_index += 1
		
		if index.size() == 1:
			state = STATE.WAITING
			return
		await spawn_group(index)
		
	complete = true
	if state == STATE.SPAWNING:
		state = STATE.WAITING
	enemies_alive += 1
	enemy_died()
			
	
func spawn_group(group: Array):
	var enemy_scene: PackedScene = group[0]
	var count: int = group[1]
	var path: Path2D = group[3]
	var interval = group[2]
	
	for i in count:
		var enemy: Enemy = enemy_scene.instantiate()
		enemy_node.add_child(enemy)
		enemy.setup(path, 0)
		enemies_alive += 1
		await get_tree().create_timer(interval).timeout
	
		
func enemy_died():
	enemies_alive -= 1
	if enemies_alive <= 0 and complete:
		emit_signal("level_cleared")
	if enemies_alive <= 0 and state == STATE.WAITING:
		emit_signal("wave_ended")
		
func start_next_wave():
	if state == STATE.WAITING:
		state = STATE.SPAWNING	
	process_next()
