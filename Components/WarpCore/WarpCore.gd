extends Node2D

export(bool) var on: bool = true

## out
var outputPlasma: float setget changeOutputPlasma
signal outputPlasmaChanged(outputPlasma)
var outputPower: float setget changeOutputPower
signal outputPowerChanged(outputPower)

## in
var inMatterFlow: float setget changeInMatterFlow
var inAntiMatterFlow: float setget changeInAntiMatterFlow

## stats
var health: float setget changeHealth
signal healthChanged(health)
var heat: float setget changeHeat
var pressure: float setget changePressure

func _ready():
	if(on):
		outputPower = inMatterFlow * inAntiMatterFlow
		outputPlasma = inMatterFlow - inAntiMatterFlow


func changeHealth(newHealth: float):
	health = newHealth
	emit_signal("healthChanged", health)
	$health.text = health

func changeOutputPlasma(newOutputPlasma: float):
	outputPlasma = newOutputPlasma
	emit_signal("outputPlasmaChanged", outputPlasma)
	
func changeOutputPower(newOutputPower: float):
	outputPower = newOutputPower
	emit_signal("outputPowerChanged", outputPower)

func changeInMatterFlow(newInMatterFlow: float):
	inMatterFlow = newInMatterFlow
	
func changeInAntiMatterFlow(newInAntiMatterFlow: float):
	inAntiMatterFlow = newInAntiMatterFlow

func changeHeat(newHeat: float):
	heat = newHeat
	$heat.text = heat
	
func changePressure(newPressure: float):
	pressure = newPressure
	$pressure.text = pressure
