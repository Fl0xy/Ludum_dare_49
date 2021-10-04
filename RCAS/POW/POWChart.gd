tool
extends Node2D

const MAX_POWER = 11
const MAX_HIGHT = 46
const WIDTH = 11

export(float) var inPower: float = 0 setget changeInPower

func changeInPower(newInPower: float):
	inPower = newInPower
	$bar.scale = Vector2(WIDTH, clamp(-(float(MAX_HIGHT)*inPower), -MAX_HIGHT, 0))
	
