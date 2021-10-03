extends Node2D

export(Color, RGBA) var color setget changeColor
export(int) var length = 100 setget changeLength
export(float) var value = 1 setget changeValue

func _ready():
	pass # Replace with function body.

func changeValue(newValue: float):
	value = newValue
	$Node2D/Sprite.scale = Vector2(newValue*length,10)

func changeColor(color: Color):
	$Node2D/Sprite.modulate = color
	
func changeLength(newLength: int):
	length = newLength
	$Node2D/Sprite.scale = Vector2(value*newLength,10)
