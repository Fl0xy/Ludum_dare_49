tool
extends Node2D

const MAX_POWER = 11
const MAX_HIGHT = 23
const WIDTH = 11

export(float) var plasmaStored setget changePlasmaStored
export(float) var plasmaStoreSize setget changePlasmaStoreSize

func changePlasma(newPlasmaStored, newPlasmaStoreSize):
	self.plasmaStoreSize = newPlasmaStoreSize
	self.plasmaStored = newPlasmaStored

func changePlasmaStoreSize(newPlasmaStoreSize):
	if (newPlasmaStoreSize == 0):
		plasmaStoreSize == 0.01
	else:
		plasmaStoreSize = newPlasmaStoreSize

func changePlasmaStored(newPlasmaStored):
	plasmaStored = newPlasmaStored
	if (plasmaStored < 0): # antimatter
		$bar.modulate = Style.ANTIMATTER_COLOR
	else:
		$bar.modulate = Style.MATTER_COLOR
	$bar.scale = Vector2(WIDTH, clamp((float(MAX_HIGHT)/self.plasmaStoreSize*plasmaStored), -MAX_HIGHT, MAX_HIGHT))
	
	

