extends Node2D

const DISPLAY_WIDTH = 84
const DISPLAY_HIGHT = 14

export(bool) var on: bool = true
export(float) var matStoreSize: float
export(float) var matStoreFullDamageTime: float
onready var timer: float = matStoreFullDamageTime

## device
var devices = []
var antiMatterDevices = []
var matterDevices = []

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
var matStore: float setget changeMatStore
signal matStoreChanged(stored, maxStore)

func _ready():
	randomize()
	self.health = 1
	self.inMatterFlow = 0
	self.inAntiMatterFlow = 0
	
	
func  _process(delta):
	if(on):
		## output
		if (self.inMatterFlow < self.inAntiMatterFlow):
			self.outputPower = self.inMatterFlow
		else:
			self.outputPower = self.inAntiMatterFlow
		self.outputPlasma = self.inMatterFlow - self.inAntiMatterFlow
		
		# power devices
		for device in self.devices:
			device.inEnergie = self.outputPower
		
		# mat for devices
		if (self.outputPlasma < 0): # antimatter
			if (self.antiMatterDevices.empty() || self.matStore > 0):
				self.matStore += self.outputPlasma
			else:
				for device in self.antiMatterDevices:
					if (self.matStore < 0):
						self.matStore -= self.outputPlasma
						device.changeInMatter(self.outputPlasma * 2)
					else:
						device.changeInMatter(self.outputPlasma)
			for device in self.matterDevices:
				device.changeInMatter(0)
			
		elif (self.outputPlasma > 0): # matter
			if (self.matterDevices.empty() || self.matStore < 0):
				self.matStore += self.outputPlasma
			else:
				for device in self.matterDevices:
					if (self.matStore > 0):
						self.matStore -= self.outputPlasma
						device.changeInMatter(self.outputPlasma * 2)
					else:
						device.changeInMatter(self.outputPlasma)
			for device in self.antiMatterDevices:
				device.changeInMatter(0)
		else: # plasma 0
			for device in self.matterDevices:
				device.changeInMatter(0)
			for device in self.antiMatterDevices:
				device.changeInMatter(0)
		
		# mat store damage
		if (self.timer <= 0):
			self.health -= 0.1 # damage
			self.timer = self.matStoreFullDamageTime
		
		if (matStore > matStoreSize):
			self.timer -= delta # timer tick
		else: # repair
			if (self.timer < self.matStoreFullDamageTime):
				self.timer += delta/2
				
		# Display
		var g = self.inAntiMatterFlow + self.inMatterFlow
		if (g != 0):
			$antiMatterBar.scale = Vector2(clamp(-(DISPLAY_WIDTH/g*self.inAntiMatterFlow), -DISPLAY_WIDTH, 0), DISPLAY_HIGHT)
			$matterBar.scale = Vector2(clamp(DISPLAY_WIDTH/g*self.inMatterFlow, 0, DISPLAY_WIDTH), DISPLAY_HIGHT)
		else:
			$antiMatterBar.scale = Vector2(0,DISPLAY_HIGHT)
			$matterBar.scale = Vector2(0,DISPLAY_HIGHT)
			

func connectDevice(device: Device):
	if (self.devices.has(device)):
		return # is connected
	devices.append(device)
	if (device.mbufSize < 0): # antimatterDevice
		self.antiMatterDevices.append(device)
	elif (device.mbufSize > 0): # matterDevice
		self.matterDevices.append(device)
	
func disconnectDevice(device: Device):
	self.devices.erase(device)
	self.antiMatterDevices.erase(device)
	self.matterDevices.erase(device)

func changeHealth(newHealth: float):
	if newHealth < health:
		$AnimationPlayer.play("reactor_gets_damaged")
	health = newHealth
	emit_signal("healthChanged", health)
	$health.text = str(health)

func changeOutputPlasma(newOutputPlasma: float):
	outputPlasma = newOutputPlasma
	$outMat.text = str(outputPlasma)
	emit_signal("outputPlasmaChanged", outputPlasma)
	
func changeOutputPower(newOutputPower: float):
	outputPower = newOutputPower
	$outPow.text = str(outputPower)
	emit_signal("outputPowerChanged", outputPower)

func changeInMatterFlow(newInMatterFlow: float):
	inMatterFlow = newInMatterFlow
	$inMat.text = str(inMatterFlow)
	
func changeInAntiMatterFlow(newInAntiMatterFlow: float):
	inAntiMatterFlow = newInAntiMatterFlow
	$inAmat.text = str(inAntiMatterFlow)
	
func changeMatStore(newMatStore: float):
	matStore = clamp(newMatStore, -self.matStoreSize*1.01,self.matStoreSize*1.01) 
	$storeMat.text = str(matStore)
	emit_signal("matStoreChanged", matStore, matStoreSize)
