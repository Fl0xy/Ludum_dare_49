extends Node2D

func remove_self():
	get_parent().remove_child(self)
	queue_free()
	# print("yas") # debug
