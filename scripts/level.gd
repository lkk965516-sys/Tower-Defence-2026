class_name Level
extends Node2D

@onready var wave_manager: WaveManager = $WaveManager
@onready var economy: Economy = $Economy
@onready var winner_ui: WINNERUI = get_node("/root/Level/ui/winnerSlot")

@export var lives: int = 30

var current_wave: int = 0
var total_waves: int = 1
var wave_in_progress: bool = false

var wave_data = [
	
]
var enemy1 = preload("res://level/enemies/enemy.tscn")
var enemy2 = preload("res://level/enemies/enemy02.tscn")
var enemy3 = preload("res://level/enemies/enemy03.tscn")

signal info_updated

func _ready() -> void:
	winner_ui.close()
	AudioManager.play_sfx("game_start")
	AudioManager.play_music("song_1")
	
	wave_data = [
			# Wave 1 - basics, single path
		[enemy1, 5, 1.5, $paths/path01],
		[-1],
		# Wave 2 - more basics
		[enemy1, 8, 1.0, $paths/path01],
		[-1],
		# Wave 3 - multiple paths
		[enemy1, 5, 1.0, $paths/path01],
		[enemy1, 5, 1.0, $paths/path02],
		[-1],
		# Wave 4 - fast enemies introduced
		[enemy1, 5, 1.0, $paths/path01],
		[enemy2, 4, 0.8, $paths/path02],
		[-1],
		# Wave 5 - more fast, multiple paths
		[enemy1, 6, 1.0, $paths/path01],
		[enemy2, 5, 0.6, $paths/path02],
		[enemy1, 4, 1.0, $paths/path03],
		[-1],
		# Wave 6 - fliers introduced
		[enemy1, 6, 1.0, $paths/path01],
		[enemy2, 4, 0.8, $paths/path02],
		[enemy3, 3, 1.0, $paths/path05],
		[-1],
		# Wave 7 - ramp up
		[enemy1, 8, 0.8, $paths/path01],
		[enemy2, 6, 0.6, $paths/path03],
		[enemy3, 5, 0.8, $paths/path05],
		[-1],
		# Wave 8 - all paths
		[enemy1, 8, 0.8, $paths/path01],
		[enemy2, 6, 0.6, $paths/path02],
		[enemy1, 6, 0.8, $paths/path03],
		[enemy3, 6, 0.7, $paths/path05],
		[-1],
		# Wave 9 - heavy pressure
		[enemy1, 10, 0.6, $paths/path01],
		[enemy2, 8, 0.5, $paths/path02],
		[enemy1, 8, 0.6, $paths/path03],
		[enemy3, 8, 0.6, $paths/path05],
		[-1],
		# Wave 10 - all out
		[enemy1, 10, 0.5, $paths/path01],
		[enemy2, 10, 0.4, $paths/path02],
		[enemy1, 8, 0.5, $paths/path03],
		[enemy2, 6, 0.4, $paths/path04],
		[enemy3, 10, 0.5, $paths/path05],
		[-1],
	]
	
	print_tree_pretty()
	for group in wave_data:
		if group.size() == 1:
			total_waves +=1
	
	wave_manager.setup(wave_data)
	wave_manager.level_cleared.connect(_on_level_cleared)
	wave_manager.wave_ended.connect(end_wave)
	$Enemies.child_entered_tree.connect(_on_enemy_spawned)
	info_updated.emit()
	
func start_wave() -> void:
	if wave_in_progress:
		return
	AudioManager.play_sfx("wave_start")
	AudioManager.play_music("song_2")
	current_wave += 1
	wave_in_progress = true
	wave_manager.start_next_wave()
	info_updated.emit()

func end_wave() -> void:
	AudioManager.play_sfx("wave_end")
	AudioManager.play_music("song_1")
	wave_in_progress = false
	economy.get_wave_bonus(75)
	
func _on_enemy_spawned(enemy: Enemy) -> void:
	enemy.on_goal.connect(_on_enemy_reached_goal)
	
func _on_enemy_reached_goal() -> void:
	lives -= 1
	AudioManager.play_sfx("lose_life")
	info_updated.emit()
	if lives <= 0:
		AudioManager.play_sfx("game_over")
		get_tree().reload_current_scene()
	
func _on_level_cleared() -> void:
	AudioManager.stop_music()
	AudioManager.play_sfx("game_win")
	winner_ui.open(lives)
