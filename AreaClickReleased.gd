extends Area2D

signal clicked
signal click_released;

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("clicked")
		else:
			emit_signal("click_released")
		#print("clicked") # debug
