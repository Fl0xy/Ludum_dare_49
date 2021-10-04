extends Node2D

export(float) var delay = 0.5
var timer: float
var check: bool = false

signal close
var mat: int = 0
var amat: int = 0

func _ready():
	timer = delay
	$mac/antiMatterControl.connect("stateChanged", self, "setAMat")
	$mac/matterControl.connect("stateChanged", self, "setMat")

func _physics_process(delta):
	if (!visible):
		return
	
	if (timer <= 0):
		emit_signal("close")
	
	if (mat == 11 && amat == 11):
		if (!check):
			timer = delay
			check = true
		else:
			timer -= delta
	else:
		check = false


func setMat(value, egal):
	mat = value
	
func setAMat(value, egal):
	amat = value
