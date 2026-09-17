class_name Tower
extends Node2D


@export var tower_name: String = "Placeholder"
@export var tower_type: String = "Placeholder"
@export var icon: Texture2D
const  projectile_file: String = "res://projectile.tscn"


@export_group("target_priority")
@export var target_priority: String = "first"


@export_group("Stats")
@export var cost: int = 1
@export var damage: int = 0
@export var attack_speed: float = 0.0
@export var projectile_speed: float = 0.0
@export var range: float = 0.0


@export_group("Side Stats")
@export var penetration: float = 0.0
@export var aoe_radius: float = 0.0
@export var aura: bool = false
@export var multishot_val: int = 1
@export var anti_air: bool = false
@export var passthrough: bool = false
@export var enemies_killed: int = 0


@export_group("Tower Statuses")
@export var slow_val: float = 0.0
@export var stun_val: float = 0.0


@export_group("Upgrades")
@export var current_level: int = 0
@export var max_level: int = 3
@export var upgrade_cost: Array[int] = [1,2,3,-1]
@export var damage_per_upgrade: Array[int] = [1,2,3]
@export var range_per_upgrade: Array[float] = [1.0,2.0,3.0]
@export var attack_speed_per_upgrade: Array[float] = [1.0,2.0,3.0]
@export var penetration_per_upgrade: Array[float] = [1.0,2.0,3.0]

@onready var economy: Economy = get_node("/root/Level/Economy")
@onready var attack_timer: Timer = $Timer



#Sorting Algorithms
var target_priority_calculation = {
	"first": func(a, b): return a.get_progress() > b.get_progress(),
	"last": func(a, b): return a.get_progress() < b.get_progress(),
	"closest": func(a, b): return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position),
	"farthest": func (a, b): return global_position.distance_to(a.global_position) > global_position.distance_to(b.global_position),
	"strongest": func (a, b): return a.max_health > b.max_health,
	"weakest": func (a, b): return a.max_health < b.max_health
}

func _ready() -> void:
	#MetaProgression.apply_upgrades(self)
	economy.add_tower(tower_type)
	
	attack_timer.wait_time = attack_speed
	attack_timer.timeout.connect(attack)
	attack_timer.start()
func place(slot: TowerSlot) -> void:
	global_position = slot.global_position


func upgrade() -> int:
	if current_level >= max_level:
		return 0
	
	self.damage = damage_per_upgrade[current_level]
	self.range = range_per_upgrade[current_level]
	self.attack_speed = attack_speed_per_upgrade[current_level]
	attack_timer.wait_time = attack_speed
	self.penetration = penetration_per_upgrade[current_level]
	var costlocal: int = upgrade_cost[current_level]
	self.current_level += 1
	return costlocal
	
	
func sell() -> int:
	var sell_price: float = cost

	for i in (current_level):
		sell_price += upgrade_cost[i]
	sell_price = sell_price * 0.5	
	destroy()
	return round(sell_price)
	



func destroy() -> void:
	economy.remove_tower(tower_type)
	queue_free()

func on_kill(enemy: Enemy) -> void:
	enemies_killed += 1
	economy.add_currency(tower_type, enemy.value)
	
func find_target() -> Enemy:
	var enemies_in_range: Array[Enemy] = []
	var my_position = global_position
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var distance = my_position.distance_to(enemy.global_position)
		if distance < range:
			if !(enemy.flying and !anti_air):
				enemies_in_range.append(enemy)
				
	if enemies_in_range.is_empty():
		return null
	
	enemies_in_range.sort_custom(target_priority_calculation[target_priority])
	return enemies_in_range[0]



func predict_target_position(enemy : Enemy) -> Vector2:
	look_at(enemy.global_position)
	var enemy_velocity = enemy.get_current_speed() * enemy.get_movement_direction()
	var enemy_to_tower = global_position - enemy.global_position
	
	var a = enemy_velocity.dot(enemy_velocity) - (projectile_speed * projectile_speed)
	var b = 2.0 * enemy_to_tower.dot(enemy_velocity)
	var c = enemy_to_tower.dot(enemy_to_tower)
	
	var discriminant = (b * b) - (4.0 * a * c)
	
	if discriminant < 0:
		return enemy.global_position
	
	var t = (-b - sqrt(discriminant)) / (2.0 * a)
	
	if t < 0:
		t = (-b + sqrt(discriminant)) / (2.0 * a)
		
	if t < 0:
		return enemy.global_position
		
	return enemy.global_position + enemy_velocity * t
		
		
		
func attack() -> void:
	if aura:
		apply_area_damage()
		return
	
	var target = find_target()
	if target == null:
		return
	AudioManager.play_sfx("shoot")
	var intercept: Vector2 = predict_target_position(target)
	var direction: Vector2 = (intercept - global_position).normalized()
	
	var projectile: Projectile = load("res://level/projectile.tscn").instantiate()
	get_tree().current_scene.get_node("Projectiles").add_child(projectile)
	
	projectile.global_position = global_position
	projectile.setup(
		self,
		direction,
		projectile_speed,
		range,
		damage,
		tower_name,
		penetration,
		slow_val,
		stun_val,
		passthrough,
		aoe_radius
	)


func apply_area_damage() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var distance = global_position.distance_to(enemy.global_position)
		if distance < range:
			if !(enemy.flying and !anti_air):
				enemy.on_death.connect(on_kill, CONNECT_ONE_SHOT)
				enemy.take_damage(damage)
				if not enemy.dying:
					enemy.on_death.disconnect(on_kill)
				if slow_val:
					enemy.add_slow(slow_val)
				if stun_val:
					enemy.add_stun(stun_val)

func change_target_forward() -> void:
	target_priority = global_tower.target_priority_dictionary_forward.get(target_priority)



func change_target_backward() -> void:
	target_priority = global_tower.target_priority_dictionary_backward.get(target_priority)
	
