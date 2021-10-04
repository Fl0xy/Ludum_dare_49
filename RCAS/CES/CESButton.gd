class_name CESButton
extends Node2D

export var OnColorName : String = ""
export var OffColorName : String = ""

var OnColor : Color = Color(1,1,1)
var OffColor : Color = Color(0,0,0)

func _ready():
	var on = Style.get_script().get_script_constant_map().get(OnColorName)
	if on != null:
		OnColor = on
	
	var off = Style.get_script().get_script_constant_map().get(OffColorName)
	if off != null:
		OffColor = off
