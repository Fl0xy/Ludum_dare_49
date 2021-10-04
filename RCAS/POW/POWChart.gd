tool
extends Node2D

const MAX_POWER = 11
const MAX_HIGHT = 46
const WIDTH = 11

export(float) var inPower setget changeInPower

func _ready():
	pass # Replace with function body.


func changeInPower(newInPower):
	inPower = newInPower
	$bar.scale = Vector2(WIDTH, clamp(-(float(MAX_HIGHT)/11*inPower), -MAX_HIGHT, 0))
	
