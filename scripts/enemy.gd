class_name Enemy
extends Node2D

@export_category("INFO")
@export var enemy_name: String = "PLACEHOLDER"

@export_category("STATS")
@export var max_health: int = 1
@export var current_hp: int = max_health
@export var base_speed: float = 1.0
@export var flying: bool = false

@export_category("STATUS")
@export var slow_resistance: float = 0.0
@export var stun_resistance: float = 0.0
@export var slow_duration: float = 0.0
@export var stun_duration: float = 0.0
@export var overclocked: bool = false
@export var protected: bool = false
@export var value: int = 1


@onready var wavemanager: WaveManager = get_node("/root/Level/WaveManager")

var path_follow: PathFollow2D
var remote_transform: RemoteTransform2D
var dying: bool = false

signal took_damage
signal on_death
signal on_goal

func _process(delta: float) -> void:
	move(delta)
	update_status_effects(delta)
	
func  _ready() -> void:
	current_hp = max_health
	add_to_group("enemies")
	
func setup(path: Path2D, start_progress: float = 0.0) -> void:
	path_follow = PathFollow2D.new()
	path_follow.loop = false
	path.add_child(path_follow)
	
	remote_transform = RemoteTransform2D.new()
	path_follow.add_child(remote_transform)
	path_follow.progress = start_progress
	
	await get_tree().process_frame
	remote_transform.remote_path = get_path()
	
	
func move(delta: float) -> void:
	if stun_duration > 0:
		return
	var speed = get_current_speed()
	
	path_follow.progress += speed * delta
	if path_follow.progress_ratio >= 1.0:
		reach_goal()
	
	
	
func take_damage(damage: int) -> void:
	var actdamage: float = damage
	if dying:
		return
	
	AudioManager.play_sfx("enemy_hurt")
	
	if overclocked:
		actdamage = actdamage * 1.5
	if protected:
		actdamage = actdamage * 0.65
	current_hp -= int(actdamage)
	took_damage.emit()
	flash_red()
	queue_redraw()
	if current_hp < 1:
		die()
	
	
func die() -> void:
	dying = true
	AudioManager.play_sfx("enemy_die")
	wavemanager.enemy_died()
	on_death.emit(self)
	if path_follow:
		path_follow.queue_free()
	queue_free()
	

func reach_goal() -> void:
#reduce lives and such	
	on_goal.emit()
	die()
	
func update_status_effects(delta: float) -> void:
	if slow_duration <= 0:
		slow_duration = 0
	else:
		slow_duration -= 1 * delta
	
	if stun_duration <= 0:
		stun_duration = 0
	else:
		stun_duration-= 1 * delta

func add_stun(stun: float) -> void:
	if stun_duration < stun * (1 - stun_resistance):
		stun_duration = stun * (1 - stun_resistance)

func add_slow(slow: float) -> void:
	print("add_slow called: ", slow, " current: ", slow_duration)
	if  slow_duration < slow:
		slow_duration = slow
	
func get_progress() -> float:
	return path_follow.progress
	
func get_movement_direction() -> Vector2:
	if path_follow == null:
		return Vector2.ZERO
	return path_follow.transform.x.normalized()

func get_current_speed() -> float:
	if stun_duration > 0:
		return 0
		
	var speed = base_speed
	if overclocked:
		speed = speed * 1.2
	if slow_duration > 0:
		speed = speed * (0.8 + slow_resistance * 0.2)
	return speed * 20

func _draw() -> void:
	var bar_width = 32.0
	var bar_height = 4.0
	var offset = Vector2(-bar_width / 2, -40)  # centered above the enemy
	
	# Background
	draw_rect(Rect2(offset, Vector2(bar_width, bar_height)), Color.DARK_GRAY)
	
	# Health fill
	var hp_percent = float(current_hp) / float(max_health)
	draw_rect(Rect2(offset, Vector2(bar_width * hp_percent, bar_height)), Color.RED)

func flash_red() -> void:
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.15)
