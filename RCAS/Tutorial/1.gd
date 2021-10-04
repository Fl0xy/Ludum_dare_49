extends Node2D

signal close()

func _on_Button_pressed():
	emit_signal("close")
