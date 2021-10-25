tool
extends Node2D

export var radius: float = 10.0

func _draw():
	draw_circle(Vector2.ZERO, radius, Color.white)
