tool
extends Node2D
class_name Device

const BAR_LENGTH: int  = 22

export(bool) var top: bool = false setget changeTop
export(String) var dname: String = "WARP" setget changeName
export(float) var eusage: float = 0 setget changeEUsage
export(float) var musage: float = 0 setget changeMUsage
export(float) var inEnergie setget changeInEnergie
export(float) var inMatter setget changeInMatter
export(float) var ebufSize: float = 100 setget changeEBufSize
export(float) var mbufSize: float = 100 setget changeMBufSize
export(float) var timeToDead: float = 100
export(bool) var connected: bool = false setget changeConnected
export(Resource) var powerStartSound: Resource setget setPowerStartSound
export(Resource) var powerSustainSound: Resource setget setPowerSustainSound
export(Resource) var powerEndSound: Resource setget setPowerEndSound

var timer: float setget changeTimer
var ebuf: float setget changeEbuf
var mbuf: float setget changeMbuf


signal deviceConnect(device)
signal deviceDisconnect(device)
signal feedbackloop()

func _ready():
	$Area2D.connect("input_event", self, "area2DClickedHelper")
	timer = timeToDead
	$soundPowerStart.connect("finished", self, "startSoundFinished")
	
	self.ebuf = self.ebufSize / 2
	if (self.mbufSize != 0):
		self.mbuf = self.mbufSize / 2

func area2DClickedHelper(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		toggle()

func _physics_process(delta):
	if (!visible):
		return
	
	if (!self.connected):
		self.inEnergie = 0
		self.inMatter = 0
	
	var damage: bool = false
	
	if (self.ebuf < self.ebufSize * 1.01):
		self.ebuf += self.inEnergie
	
	# take energie from buffer
	if (self.ebuf > 0):
		self.ebuf -= self.eusage
		
	## check energie buffer full or empty
	if (self.ebuf >= self.ebufSize || self.ebuf <= 0):
		damage = true
	
	if (mbufSize > 0): #matter mode
		if (self.mbuf < self.mbufSize * 1.01):
			self.mbuf += self.inMatter
		if (self.mbuf > 0):
			self.mbuf -= self.musage
		if (self.mbuf >= self.mbufSize || self.mbuf <= 0):
			damage = true
	elif (mbufSize < 0): #antimatter mode
		if (self.mbuf > self.mbufSize * 1.01):
			self.mbuf += self.inMatter
		if (self.mbuf < 0):
			self.mbuf -= self.musage
		if (self.mbuf <= self.mbufSize || self.mbuf >= 0):
			damage = true
	
	# Damage
	if (damage):
		self.timer -= delta
	else:
		if (timer < timeToDead):
			self.timer += delta / 2
	if (self.timer < 0):
		emit_signal("feedbackloop")
		self.timer = timeToDead
		


func deviceDisconnect():
	self.connected = false

func toggle():
	changeConnected(!connected)

func changeConnected(newConnected: bool):
	connected = newConnected
	if (connected):
		$ui_device_name_tag.modulate = Style.ON_COLOR
		$ebar.on = true
		$mbar.on = true
		emit_signal("deviceConnect", self)
	else:
		$ui_device_name_tag.modulate = Style.OFF_COLOR
		$ebar.on = false
		$mbar.on = false
		emit_signal("deviceDisconnect", self)

func changeEbuf(newEbuf: float):
	ebuf = newEbuf
	$ebar.value = ebuf
	
func changeMbuf(newMbuf: float):
	mbuf = newMbuf
	$mbar.value = abs(mbuf)
	
func changeEUsage(newEUsage: float):
	# sound
	if (eusage == 0 && newEUsage > 0):
		$soundPowerStart.play(0)
	elif(eusage > 0 && newEUsage == 0):
		$soundPowerSustain.stop()
		$soundPowerEnd.play(0)
	# values
	eusage = newEUsage
	if (eusage != 0):
		$ebar.discarge = true
	else:
		$ebar.discarge = false
	
func changeMUsage(newMUsage: float):
	musage = newMUsage
	if (musage != 0):
		$mbar.discarge = true
	else:
		$mbar.discarge = false
	
func changeInEnergie(newInEnergie: float):
	inEnergie = newInEnergie
	
func changeInMatter(newInMatter: float):
	inMatter = newInMatter
	
func changeTimer(newTimer):
	timer = newTimer
	
func changeName(newName):
	dname = newName
	$name.text = dname

func changeEBufSize(newEBufSize):
	ebufSize = newEBufSize
	$ebar.maxValue = ebufSize
	
func changeMBufSize(newMBufSize):
	mbufSize = newMBufSize
	if (mbufSize < 0): # antimatter
		$mbar.maxValue = abs(mbufSize)
		$mbar.mode = $mbar.modeState.anitmatter
	elif (mbufSize > 0): # matter
		$mbar.maxValue = mbufSize
		$mbar.mode = $mbar.modeState.matter
	else: # off
		$mbar.mode = $mbar.modeState.off
		
func changeTop(newTop):
	top = newTop
	if(top):
		$ui_device_border.scale = Vector2(1,-1)
		$ui_device_name_tag.scale = Vector2(1,-1)
		$Area2D.scale = Vector2(1,-1)
		$name.rect_position = Vector2(6,-28)
		$ebar.position = Vector2(3,-14)
		$mbar.position = Vector2(3,-8)
		$mbar.rotate = true
	else:
		$ui_device_border.scale = Vector2(1,1)
		$ui_device_name_tag.scale = Vector2(1,1)
		$Area2D.scale = Vector2(1,1)
		$name.rect_position = Vector2(6,19)
		$ebar.position = Vector2(3, 9)
		$mbar.position = Vector2(3, 3)
		$mbar.rotate = false

func setPowerStartSound(newPowerStartSound):
	powerStartSound = newPowerStartSound
	$soundPowerStart.stream = powerStartSound
	
func setPowerSustainSound(newPowerSustainSound):
	powerSustainSound = newPowerSustainSound
	$soundPowerSustain.stream = powerSustainSound
	
func setPowerEndSound(newPowerEndSound):
	powerEndSound = newPowerEndSound
	$soundPowerEnd.stream = powerEndSound
	
func startSoundFinished():
	if (self.eusage > 0):
		$soundPowerSustain.play(0)
