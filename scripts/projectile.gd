class_name Projectile
extends Node2D

var tower: Tower
var direction: Vector2
var speed: float
var max_distance: float
var distance_traveled: float
var enemies_hit: Array[Enemy]
var damage: int
var damage_type: String
var penetration: float
var slow_val: float
var stun_val: float
var pass_through: bool
var aoe_radius: float
var aoe_sprite: Sprite2D
var tower_type: String
var dying: bool = false

@onready var economy: Economy = get_node("/root/Level/Economy")


func _ready() -> void:
	$Area2D.area_entered.connect(_on_area_entered)
	
	
	
	
func setup(tower_: Tower, direction_: Vector2, speed_: float, max_distance_: float, damage_: int, damage_type_: String, penetration_: float, slow_val_: float, stun_val_: float, passthrough_: bool, aoe_radius_: float) -> void:
	tower = tower_
	direction = direction_
	speed = speed_
	max_distance = max_distance_
	damage = damage_
	damage_type = damage_type_
	penetration = penetration_
	slow_val = slow_val_
	stun_val = stun_val_
	pass_through = passthrough_
	aoe_radius = aoe_radius_
	aoe_sprite = $Sprite2D2
	tower_type = tower_.tower_type
	aoe_sprite.visible = false
	if aoe_radius > 0:
		aoe_sprite.visible = false
		aoe_sprite.scale = Vector2.ONE * (aoe_radius * 2.0/ aoe_sprite.texture.get_width())
func _process(delta: float) -> void:
	move(delta)

func _on_area_entered(body: Area2D) -> void:
	if dying:
		return
	print("area entered: ", body.get_parent().name, " is enemy: ", body.get_parent() is Enemy)
	print("hit: ", body.get_parent().name)
	var enemy = body.get_parent()
	if enemy is Enemy:
		if enemies_hit.has(enemy):
			return
		
		if aoe_radius:
				aoe_sprite.visible = true
				apply_area_damage()	
		on_hit(enemy)
		return

func move(delta: float) -> void:
	if dying:
		return
	if distance_traveled >= max_distance:
		destroy()
		return
	
	var movement = direction * speed * delta
	global_position += movement
	distance_traveled += movement.length()
	rotation = direction.angle()
	
	
func on_hit(enemy: Enemy) -> void:
	if enemies_hit.has(enemy):
		return
	enemies_hit.append(enemy)
	if slow_val:
		enemy.add_slow(slow_val)
	if stun_val:
		enemy.add_stun(stun_val)
	
	enemy.on_death.connect(on_kill, CONNECT_ONE_SHOT)
	enemy.take_damage(damage)
	enemy.on_death.disconnect(on_kill)
	
	if !pass_through && !enemy.dying:
		destroy()
		
		
func on_kill(enemy: Enemy) -> void:
	if is_instance_valid(tower):
		tower.on_kill(enemy)
	else:
		economy.add_currency(tower_type, enemy.value)


func apply_area_damage() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var distance = global_position.distance_to(enemy.global_position)
		if distance < aoe_radius:
			on_hit(enemy)



func destroy():
	AudioManager.play_sfx("impact")
	dying = true
	if aoe_radius > 0:
		aoe_sprite.visible = true
		await get_tree().create_timer(0.2).timeout
	queue_free()
