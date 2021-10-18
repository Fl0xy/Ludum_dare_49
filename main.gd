extends Node2D

var phase_one_job: bool = false
var phase_one_timer: SceneTreeTimer

var phase_two_timer: SceneTreeTimer
var holo_job: bool = false
var holo_timer: SceneTreeTimer
var snsr_job: bool = false
var snsr_timer: SceneTreeTimer
var tnsp_job: bool = false
var tnsp_timer: SceneTreeTimer

var phase_three_timer: SceneTreeTimer
var phsr_timer: SceneTreeTimer
var phsr_job: bool = false
var phsr_burst: int = 0
var torp_timer: SceneTreeTimer
var torp_job: bool = false
var torp_burst: int = 0
var shld_timer: SceneTreeTimer
var shld_job: bool = false
var phase: int = 0 setget setPhase
var rng = RandomNumberGenerator.new()

export var time_for_completing_core_ejection: float = 0.0
var core_ejected: bool = false


func _ready():
	rng.randomize()
	
	$mmonitor/mac/antiMatterControl.connect("valueChanged", $warpCore, "changeInAntiMatterFlow")
	$mmonitor/mac/matterControl.connect("valueChanged", $warpCore, "changeInMatterFlow")
	
	$warpCore.connect("matStoreChanged", $mmonitor/mac/mamChart, "changePlasma")
	$warpCore.connect("outputPowerChanged", $mmonitor/mac/powChart, "changeInPower")
	
	$mmonitor/pcg/warp.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/warp.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/impl.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/impl.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/phsr.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/phsr.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/snsr.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/snsr.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/dflc.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/dflc.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/shld.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/shld.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/holo.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/holo.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/torp.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/torp.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/tnsp.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/tnsp.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	
	$mmonitor/pcg/phsr.visible = false
	$mmonitor/pcg/shld.visible = false
	$mmonitor/pcg/torp.visible = false
	$mmonitor/pcg/holo.visible = false
	$mmonitor/pcg/snsr.visible = false
	$mmonitor/pcg/tnsp.visible = false
	$mmonitor/pcg/warp.visible = false
	$mmonitor/pcg/impl.visible = false
	$mmonitor/pcg/dflc.visible = false
	
	$tutorial.connect("done", self, "startPhaseOne")
	
	# WARP CORE EJECTION
	$warpCore.connect("healthChanged", self, "testForAndInitateCoreEjectionProcedureIfNeeded")
	#$CES.connect("eject_core", self, )

export var screen_shake_duration = 1.0
var remaining_screen_shake_time = 0
var shake_strength

func shake_screen():
	remaining_screen_shake_time = screen_shake_duration

func testForAndInitateCoreEjectionProcedureIfNeeded(coreHealth):
	print(coreHealth)
	shake_strength = 10 * min((1 - coreHealth), 1)
	shake_screen()
	
	if coreHealth <= 0: # then the core cannot be recovered, it has to be ejected
		get_tree().create_timer(time_for_completing_core_ejection).connect("timeout", self, "handleCoreEjectionTimeout")


func handleCoreEjectionTimeout():
	# TODO:
	# start timer for core explosion : gameover
	# make the toggle button of the CES flash red!
	# make the reactor flash red
	
	if !core_ejected:
		print("core exploded")
	else:
		print("core exploded safely outside the ship")


func _process(delta):
	if remaining_screen_shake_time > 0:
		remaining_screen_shake_time -= delta
		position.x = shake_strength * (posmod(randi(),3) - 1)
		position.y = shake_strength * (posmod(randi(),3) - 1)
		
	else:
		position.x = 0
		position.y = 0

func _physics_process(delta):
	if (phase >= 1): #phase 1
		if (!phase_one_job):
			var j = rng.randi() % 2
			if (j == 0):
				$mmonitor/pcg/impl.eusage = rng.randf_range(0.0, 0.0)
				$mmonitor/pcg/impl.musage = rng.randf_range(0.0, 0.0)
				$mmonitor/pcg/warp.eusage = rng.randf_range(0.1, 0.5)
				$mmonitor/pcg/dflc.eusage = rng.randf_range(0.1, 0.4)
				$mmonitor/pcg/dflc.musage = -rng.randf_range(0.1, 0.2)
				self.phase_one_timer = get_tree().create_timer(rng.randf_range(15, 30))
			else: # impluse job
				$mmonitor/pcg/warp.eusage = rng.randf_range(0.0, 0.0)
				$mmonitor/pcg/dflc.eusage = rng.randf_range(0.0, 0.0)
				$mmonitor/pcg/dflc.musage = rng.randf_range(0.0, 0.0)
				$mmonitor/pcg/impl.eusage = rng.randf_range(0.1, 0.2)
				$mmonitor/pcg/impl.musage = rng.randf_range(0.3, 0.6)
				self.phase_one_timer = get_tree().create_timer(rng.randf_range(15, 30))
			self.phase_one_timer.connect("timeout", self, "phaseOneJobDone")
			self.phase_one_job = true
			
	if (phase >= 2): #phase 2
		if (!holo_job):
			var j = rng.randi() % 2
			if (j == 0): # off
				$mmonitor/pcg/holo.eusage = 0
				$mmonitor/pcg/holo.musage = 0
				self.holo_timer = get_tree().create_timer(rng.randf_range(30,60))
			else: # on
				$mmonitor/pcg/holo.eusage = rng.randf_range(0.1, 0.2)
				$mmonitor/pcg/holo.musage = rng.randf_range(0.1, 0.2)
				self.holo_timer = get_tree().create_timer(rng.randf_range(30,60))
			self.holo_timer.connect("timeout", self, "holoJobDone")
			self.holo_job = true
			
		if (!snsr_job):
			var j = rng.randi() % 10
			if (j < 7): # 60% low load
				$mmonitor/pcg/snsr.eusage = rng.randf_range(0.2, 0.4)
				self.snsr_timer = get_tree().create_timer(rng.randf_range(30,60))
			elif (j < 9): #30% off
				$mmonitor/pcg/snsr.eusage = 0
				self.snsr_timer = get_tree().create_timer(rng.randf_range(30,60))
			else: # 10% burst
				$mmonitor/pcg/snsr.eusage = rng.randf_range(0.4, 0.6)
				self.snsr_timer = get_tree().create_timer(rng.randf_range(0.5,3))
			self.snsr_timer.connect("timeout", self, "snsrJobDone")
			self.snsr_job = true
			
		if (!tnsp_job):
			var j = rng.randi() % 10
			if (j < 2): # 20% burst
				$mmonitor/pcg/tnsp.eusage = rng.randf_range(0.8, 1)
				$mmonitor/pcg/tnsp.musage = rng.randf_range(0.8, 1)
				self.tnsp_timer = get_tree().create_timer(2)
			else: # 80% off
				$mmonitor/pcg/tnsp.eusage = 0
				$mmonitor/pcg/tnsp.musage = 0
				self.tnsp_timer = get_tree().create_timer(rng.randf_range(10,30))
			self.tnsp_timer.connect("timeout", self, "tnspJobDone")
			self.tnsp_job = true
	
	if (phase >= 3):
		if (!phsr_job):
			if (phsr_burst != 0):
				if ($mmonitor/pcg/phsr.eusage == 1): # is shooting -> turn off
					$mmonitor/pcg/phsr.eusage = 0
					$mmonitor/pcg/phsr.musage = 0
					self.phsr_timer = get_tree().create_timer(rng.randf_range(2,3))
				else: # is not shooting -> turn on
					$mmonitor/pcg/phsr.eusage = 1
					$mmonitor/pcg/phsr.musage = -1
					self.phsr_timer = get_tree().create_timer(rng.randf_range(0.5,1))
				self.phsr_timer.connect("timeout", self, "phsrJobDone")
				self.phsr_job = true
			else:
				var j = rng.randi() % 10
				if (j < 2): # 20% burst
					phsr_burst = (rng.randi() % 6) + 5 # 5-10 bursts
				else:
					$mmonitor/pcg/phsr.eusage = 0
					$mmonitor/pcg/phsr.musage = 0
					self.phsr_timer = get_tree().create_timer(rng.randf_range(20,40))
					self.phsr_timer.connect("timeout", self, "phsrJobDone")
					self.phsr_job = true
		
		if (!torp_job):
			if (torp_burst != 0):
				if ($mmonitor/pcg/torp.eusage == 1): # is shooting -> turn off
					$mmonitor/pcg/torp.eusage = 0
					$mmonitor/pcg/torp.musage = 0
					self.torp_timer = get_tree().create_timer(rng.randf_range(2,3))
				else: # is not shooting -> turn on
					$mmonitor/pcg/torp.eusage = 0.5
					$mmonitor/pcg/torp.musage = -1
					self.torp_timer = get_tree().create_timer(rng.randf_range(0.5,1))
				self.torp_timer.connect("timeout", self, "torpJobDone")
				self.torp_job = true
			else:
				var j = rng.randi() % 10
				if (j < 2): # 20% burst
					torp_burst = (rng.randi() % 5) + 2 # 2-6 bursts
				else: # 80% off
					$mmonitor/pcg/torp.eusage = 0
					$mmonitor/pcg/torp.musage = 0
					self.torp_timer = get_tree().create_timer(rng.randf_range(30,60))
					self.torp_timer.connect("timeout", self, "torpJobDone")
					self.torp_job = true
		
		if(!shld_job):
			var j = rng.randi() % 10
			if (j < 3): # 30% high
				$mmonitor/pcg/shld.eusage = rng.randf_range(0.5, 0.8)
				self.shld_timer = get_tree().create_timer(2)
			else: # 70% low
				$mmonitor/pcg/shld.eusage = rng.randf_range(0.2, 0.4)
				self.shld_timer = get_tree().create_timer(rng.randf_range(10,40))
			self.shld_timer.connect("timeout", self, "shldJobDone")
			self.shld_job = true
		

func startPhaseOne():
	self.phase = 1
	phase_two_timer = get_tree().create_timer(60)
	phase_two_timer.connect("timeout", self, "startPhaseTwo")
	
func startPhaseTwo():
	self.phase = 2
	phase_three_timer = get_tree().create_timer(300)
	phase_three_timer.connect("timeout", self, "startPhaseThree")
	
func startPhaseThree():
	self.phase = 3
	
func phaseOneJobDone():
	self.phase_one_job = false
	
func holoJobDone():
	self.holo_job = false
func snsrJobDone():
	self.snsr_job = false
func tnspJobDone():
	self.tnsp_job = false

func phsrJobDone():
	self.phsr_job = false
func torpJobDone():
	self.torp_job = false
func shldJobDone():
	self.shld_job = false
	
func setPhase(newPhase):
	phase = newPhase
	match phase:
		3:
			$mmonitor/pcg/phsr.visible = true
			$mmonitor/pcg/shld.visible = true
			$mmonitor/pcg/torp.visible = true
			continue
		2:
			$mmonitor/pcg/holo.visible = true
			$mmonitor/pcg/snsr.visible = true
			$mmonitor/pcg/tnsp.visible = true
			continue
		1:
			$mmonitor/pcg/warp.visible = true
			$mmonitor/pcg/impl.visible = true
			$mmonitor/pcg/dflc.visible = true
		

func makeKaputt():
	$warpCore.changeHealth($warpCore.health - 0.1)
