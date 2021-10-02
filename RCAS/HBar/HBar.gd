extends Node2D

export(Color, RGBA) var color setget changeColor
export(String) var unit = "TW" setget changeUnit
export(int) var length = 100 setget changeLength
export(float) var value = 1 setget changeValue

func _ready():
	pass # Replace with function body.

func changeValue(newValue: float):
	value = newValue
	$Sprite.scale = Vector2(newValue*length,10)

func changeColor(color: Color):
	$Sprite.modulate = color
	$Polygon2D.modulate = color

func changeUnit(newUnit: String):
	unit = newUnit
	$Label.text = newUnit
	
func changeLength(newLength: int):
	length = newLength
	$Sprite.scale = Vector2(value*newLength,10)
