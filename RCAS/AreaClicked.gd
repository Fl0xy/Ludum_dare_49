extends Area2D

signal clicked;

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		emit_signal("clicked")
		#print("clicked") # debug
