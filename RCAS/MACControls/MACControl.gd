extends Node2D

const MAX = 11
var value: float setget changeValue
signal valueChanged(value)

func _ready():
	self.value = 0
	$plus.connect("pressed", self, "plus")
	$minus.connect("pressed", self, "minus")
	
func plus():
	if (self.value < MAX):
		self.value += 1
		emit_signal("valueChanged", self.value/MAX)

func minus():
	if (self.value > 0):
		self.value -= 1
		emit_signal("valueChanged", self.value/MAX)

func changeValue(newValue):
	value = newValue
	$label.text = str(value)
	$debug.text = str(value/MAX)
