extends Node2D

export(float) var eusage setget changeEUsage
export(float) var musage setget changeMUsage
export(float) var inEnergie setget changeInEnergie
export(float) var inMatter
export(float) var ebufSize
export(float) var mbufSize
export(float) var timeToDead
export(float) var deadTime
var dead: bool 
var timer: float setget changeTimer

var connected: bool setget changeConnected
var ebuf: float setget changeEbuf
var mbuf: float setget changeMbuf


signal deviceConnect(device)
signal deviceDisconnect()

func _ready():
	$Button.connect("pressed", self, "toggle")
	dead = false
	timer = timeToDead
	
	self.connected = false
	self.ebuf = self.ebufSize / 2
	if (self.mbufSize != 0):
		self.mbuf = self.mbufSize / 2
		
func _physics_process(delta):
	
	if (!dead):
		var damage: bool = false
		# add energie to buffer
		self.ebuf += self.inEnergie
		if (self.ebuf > self.ebufSize):
			self.ebuf = self.ebufSize
		
		# take energie from buffer
		self.ebuf -= self.eusage
		if (self.ebuf < 0):
			self.ebuf = 0
			
		## check energie buffer full or empty
		if (self.ebuf == self.ebufSize || self.ebuf == 0):
			damage = true
		
		# matter antimatter suff
		if (mbufSize != 0):
			self.mbuf += self.inMatter
			if ((mbufSize < 0 && self.mbuf < self.mbufSize) || (mbufSize > 0 && self.mbuf > self.mbufSize)):
				self.mbuf = mbufSize
			
			self.mbuf -= self.musage
			if ((mbufSize < 0 && mbuf > 0) || (mbufSize > 0 && mbuf < 0)):
				self.mbuf = 0
				
			if (self.mbuf == self.mbufSize || self.mbuf == 0):
				damage = true
		
		# Damage
		if (damage):
			self.timer -= delta
		if (self.timer < 0):
			# make dead
			deviceDisconnect()
			self.timer = deadTime
			self.dead = true
	else:
		# dead
		self.timer -= delta
		if(self.timer < 0):
			self.timer = timeToDead
			self.dead = false


func deviceDisconnect():
	self.connected = false

func toggle():
	changeConnected(!connected)

func changeConnected(newConnected: bool):
	connected = newConnected
	if (connected):
		$connected.text = "true"
		emit_signal("deviceConnect", self)
	else:
		$connected.text = "false"
		emit_signal("deviceDisconnect")

func changeEbuf(newEbuf):
	ebuf = newEbuf
	$ebuf.text = str(ebuf) + "/" + str(ebufSize)
	
func changeMbuf(newMbuf):
	mbuf = newMbuf
	$ebuf.text = str(mbuf) + "/" + str(mbufSize)
	
func changeEUsage(newEUsage):
	eusage = newEUsage
	$eusage.text = str(eusage)
	
func changeMUsage(newMUsage):
	musage = newMUsage
	$musage.text = str(musage)
	
func changeInEnergie(newInEnergie):
	inEnergie = newInEnergie
	$inEnergie.text = str(inEnergie)
	
func changeInMatter(newInMatter):
	inMatter = newInMatter
	$inMatter.text = str(inMatter)
	
func changeTimer(newTimer):
	timer = newTimer
	if (dead):
		$dead.text = "true: " + str(timer)
	else:
		$dead.text = "false: " + str(timer)
