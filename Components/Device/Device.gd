extends Node2D
class_name Device

const BAR_LENGTH: int  = 23

export(float) var eusage setget changeEUsage
export(float) var musage setget changeMUsage
export(float) var inEnergie setget changeInEnergie
export(float) var inMatter setget changeInMatter
export(float) var ebufSize
export(float) var mbufSize
export(float) var timeToDead
export(bool) var connected: bool setget changeConnected

var timer: float setget changeTimer
var ebuf: float setget changeEbuf
var mbuf: float setget changeMbuf


signal deviceConnect(device)
signal deviceDisconnect(device)
signal feedbackloop()

func _ready():
	$Button.connect("pressed", self, "toggle")
	timer = timeToDead
	
	self.ebuf = self.ebufSize / 2
	if (self.mbufSize != 0):
		self.mbuf = self.mbufSize / 2
	
		
func _physics_process(delta):
	
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
		$connected.text = "true"
		emit_signal("deviceConnect", self)
		$ui_device_name_tag.modulate = Style.ON_COLOR
		$ui_device_energy_bar.modulate = Style.ON_COLOR
		$ui_device_excess_bar.modulate = Style.ON_COLOR
	else:
		$connected.text = "false"
		emit_signal("deviceDisconnect", self)
		$ui_device_name_tag.modulate = Style.OFF_COLOR
		$ui_device_energy_bar.modulate = Style.OFF_COLOR
		$ui_device_excess_bar.modulate = Style.OFF_COLOR

func changeEbuf(newEbuf: float):
	ebuf = newEbuf
	$enrBar.transform = Vector2((ebuf/self.ebufSize)*BAR_LENGTH, 3)
	$ebuf.text = str(ebuf) + "/" + str(ebufSize)
	
func changeMbuf(newMbuf: float):
	mbuf = newMbuf
	$matBar.transform = Vector2(abs((ebuf/self.ebufSize)*BAR_LENGTH), 3)
	$mbuf.text = str(mbuf) + "/" + str(mbufSize)
	
func changeEUsage(newEUsage: float):
	eusage = newEUsage
	$eusage.text = str(eusage)
	
func changeMUsage(newMUsage: float):
	musage = newMUsage
	$musage.text = str(musage)
	
func changeInEnergie(newInEnergie: float):
	inEnergie = newInEnergie
	$inEnergie.text = str(inEnergie)
	
func changeInMatter(newInMatter: float):
	inMatter = newInMatter
	$inMatter.text = str(inMatter)
	
func changeTimer(newTimer):
	timer = newTimer
	$timer.text = str(timer)
	
func changeMBufSize(newMBufSize):
	mbufSize = newMBufSize
	if (mbufSize < 0): #antimatter
		$ui_symbole_matter.visible = false
		$ui_symbole_antim.visible = true
		$matBar.modulate = Style.ANTIMATTER_COLOR
	elif(mbufSize > 0): #matter
		
