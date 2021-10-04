tool
extends Node2D

const MAX_POWER = 11
const MAX_HIGHT = 23
const WIDTH = 11

export(float) var inPlasma setget changeInPlasma

func _ready():
	pass # Replace with function body.


func changeInPlasma(newInPlasma):
	inPlasma = newInPlasma
	if (inPlasma < 0): # antimatter
		$bar.modulate = Style.ANTIMATTER_COLOR
	else:
		$bar.modulate = Style.MATTER_COLOR
	$bar.scale = Vector2(WIDTH, clamp((float(MAX_HIGHT)/11*inPlasma), -MAX_HIGHT, MAX_HIGHT))
	
