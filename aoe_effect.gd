class_name AOEEffect
extends Node2D

var radius: float
var color: Color = Color(1, 0, 0, 0.4)

func setup(radius_: float) -> void:
	radius = radius_

func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, 0, TAU, 64, color, 2.0)

func play() -> void:
	var tween = create_tween()
	tween.tween_method(set_alpha, 0.4, 0.0, 0.4)
	await tween.finished
	queue_free()

func set_alpha(value: float) -> void:
	color.a = value
	queue_redraw()
