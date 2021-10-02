extends Node2D

export(bool) var on: bool = true

## device
var device
var connected: bool setget changeConncted
signal connctedChanged(connected)

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
signal heatChanged(heat)
var pressure: float setget changePressure

func _ready():
	randomize()
	self.connected = false
	self.health = 1
	self.inMatterFlow = 0
	self.inAntiMatterFlow = 0
	
	
func  _process(delta):
	if(on):
		## output
		self.outputPower = (self.inMatterFlow * self.inAntiMatterFlow) * (1 + (randi() % 100)*0.001)
		self.outputPlasma = self.inMatterFlow - self.inAntiMatterFlow
		
		## heat
		self.heat += (self.outputPower * 0.1) * delta
		## cooling
		if (heat > 0):
			var cooling = (self.heat / 2) + 0.001
			if (cooling > 0.1):
				cooling = 0.1
			self.heat -= cooling * delta
		
		## pressure
		if (!self.connected):
			self.pressure += 0.005 * delta
		elif (self.pressure > 0):
			self.pressure -= 0.01 * delta
		else:
			self.pressure = 0
			
		## health
		if (self.heat > 1):
			self.health -= (0.01 * heat) * delta


func connectDevice(device):
	if (self.connected):
		device.disconnect("deviceDisconnect", self, "disconnectDevice")
		device.deviceDisconnect()
	self.device = device
	device.connect("deviceDisconnect", self, "disconnectDevice")
	self.connected = true
	
func disconnectDevice():
	device.disconnect("deviceDisconnect", self, "disconnectDevice")
	device = null
	self.connected = false

func changeHealth(newHealth: float):
	health = newHealth
	emit_signal("healthChanged", health)
	$health.text = str(health)

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
	emit_signal("heatChanged", heat)
	$heat.text = str(heat)
	
func changePressure(newPressure: float):
	pressure = newPressure
	$pressure.text = str(pressure)

func changeConncted(newConnected: bool):
	connected = newConnected
	if connected:
		$connected.text = "true"
	else:
		$connected.text = "false"
	emit_signal("connctedChanged", connected)
