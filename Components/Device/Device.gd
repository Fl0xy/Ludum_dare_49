tool
extends Node2D
class_name Device

const BAR_LENGTH: int  = 22

export(String) var dname: String = "WARP" setget changeName
export(float) var eusage: float = 0 setget changeEUsage
export(float) var musage: float = 0 setget changeMUsage
export(float) var inEnergie setget changeInEnergie
export(float) var inMatter setget changeInMatter
export(float) var ebufSize: float = 100
export(float) var mbufSize: float = 100 setget changeMBufSize
export(float) var timeToDead: float = 100
export(bool) var connected: bool = false setget changeConnected

var timer: float setget changeTimer
var ebuf: float setget changeEbuf
var mbuf: float setget changeMbuf


signal deviceConnect(device)
signal deviceDisconnect(device)
signal feedbackloop()

func _ready():
	$Button.connect("pressed", self, "toggle")
	$Area2D.connect("input_event", self, "area2DClickedHelper")
	timer = timeToDead
	
	self.ebuf = self.ebufSize / 2
	if (self.mbufSize != 0):
		self.mbuf = self.mbufSize / 2

func area2DClickedHelper(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		toggle()

func _physics_process(delta):
	
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
	$enrBar.scale = Vector2(clamp((ebuf/self.ebufSize)*BAR_LENGTH, 0 , BAR_LENGTH), 3)
	$ebuf.text = str(ebuf) + "/" + str(ebufSize)
	
func changeMbuf(newMbuf: float):
	mbuf = newMbuf
	$matBar.scale = Vector2(clamp(abs((mbuf/self.mbufSize)*BAR_LENGTH), 0 , BAR_LENGTH) , 3)
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
	
func changeName(newName):
	dname = newName
	$name.text = dname
	
func changeMBufSize(newMBufSize):
	mbufSize = newMBufSize
	if (mbufSize != 0):
		$ui_device_excess_bar_off.visible = false
		$ui_device_excess_bar.visible = true
		$matBar.visible = true
		if (mbufSize < 0): #antimatter
			$ui_symbole_matter.visible = false
			$ui_symbole_antim.visible = true
			$matBar.modulate = Style.ANTIMATTER_COLOR
		else: #matter
			$ui_symbole_matter.visible = true
			$ui_symbole_antim.visible = false
			$matBar.modulate = Style.MATTER_COLOR
	else: #no matter buffer
		$ui_symbole_matter.visible = false
		$ui_symbole_antim.visible = false
		$matBar.visible = false
		$ui_device_excess_bar.visible = false
		$ui_device_excess_bar_off.visible = true
