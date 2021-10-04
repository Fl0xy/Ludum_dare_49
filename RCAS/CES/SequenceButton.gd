class_name SequenceButton
extends CESButton

signal pressed

func border_on():
	$"ces_sequence-button_border".modulate = OnColor
func border_off():
	$"ces_sequence-button_border".modulate = OffColor
func is_border_on():
	return $"ces_sequence-button_border".modulate == OnColor

func inner_on():
	$"ces_sequence-button_inner".modulate = OnColor
func inner_off():
	$"ces_sequence-button_inner".modulate = OffColor
func is_inner_on():
	return $"ces_sequence-button_inner".modulate == OnColor

func press():
	if is_inner_on(): # then the button can be pressed
		border_on()
		inner_off()
		emit_signal("pressed")

func all_off():
	inner_off()
	border_off()

func _ready():
	$Area2D.connect("clicked", self, "press")
	
	all_off()
