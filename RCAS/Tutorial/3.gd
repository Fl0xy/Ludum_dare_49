extends Node2D

signal close

export(float) var delay = 0.5
var timer: float
var check: bool = false

var warp = false
var impl = false
var phsr = false

func _ready():
	timer = delay

func _physics_process(delta):
	if (!visible):
		return
			
	if (timer <= 0):
		emit_signal("close")
	
	$warp.inEnergie = 0.5
	
	$impl.inEnergie = 0.5
	$impl.inMatter = 0.5
	
	$phsr.inEnergie = 0.5
	$phsr.inMatter = -0.5
	
	if (warp && impl && phsr):
		if (!check):
			timer = delay
			check = true
		else:
			timer -= delta
	else:
		check = false

func _on_warp_deviceConnect(device):
	warp = true
func _on_warp_deviceDisconnect(device):
	warp = false
	
func _on_impl_deviceConnect(device):
	impl = true
func _on_impl_deviceDisconnect(device):
	impl = false

func _on_phsr_deviceConnect(device):
	phsr = true
func _on_phsr_deviceDisconnect(device):
	phsr = false
