extends Control

export(bool) var enable = true
export(float) var delay: float = 1
var timer: float
var one = false
var two = false
var three = false

signal done

func _ready():
	if (enable):
		get_tree().paused = true
		one = true
		timer = delay
	else:
		call_deferred("emit_signal", "done")

func _physics_process(delta):
	
	if (one):
		if (timer <= 0):
			$"1".visible = true
			one = false
		else:
			timer -= delta
			
	if (two):
		if (timer <= 0):
			$"2".visible = true
			two = false
		else:
			timer -= delta
	
	if (three):
		if (timer <= 0):
			$"3".visible = true
			three = false
		else:
			timer -= delta
	

func _on_1_close():
	$"1".visible = false
	timer = delay
	two = true


func _on_2_close():
	$"2".visible = false
	timer = delay
	three = true


func _on_3_close():
	$"3".visible = false
	get_tree().paused = false
	emit_signal("done")
	queue_free()
