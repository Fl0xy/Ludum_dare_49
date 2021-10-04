tool
extends Node2D

const MAX = 11

enum modeEnum {matter, anitmatter}
export(modeEnum) var mode
var value: float setget changeValue
signal valueChanged(value)
var state: int setget changeState
signal stateChanged(state, mode)

func _ready():
	$ui_dial_number_circle.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_number_circle, "changeState")
	$ui_dial_seg_1.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_seg_1, "changeState")
	$ui_dial_seg_2.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_seg_2, "changeState")
	$ui_dial_seg_3.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_seg_3, "changeState")
	$ui_dial_seg_4.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_seg_4, "changeState")
	$ui_dial_seg_5.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_seg_5, "changeState")
	$ui_dial_seg_6.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_seg_6, "changeState")
	$ui_dial_seg_7.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_seg_7, "changeState")
	$ui_dial_seg_8.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_seg_8, "changeState")
	$ui_dial_seg_9.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_seg_9, "changeState")
	$ui_dial_seg_10.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_seg_10, "changeState")
	$ui_dial_seg_11.connect("pressed", self, "_on_Area2D_pressed")
	connect("stateChanged", $ui_dial_seg_11, "changeState")
	
	if (mode == modeEnum.matter):
		$Label.text = "MATTER"
	else:
		$Label.text = "ANTI-M"
	
	self.state = 0

func changeState(newState: int):
	state = newState
	$ui_dial_number_circle/label.text = str(state)
	self.value = float(state)/MAX
	emit_signal("stateChanged", state, mode)

func changeValue(newValue):
	value = newValue
	emit_signal("valueChanged", value)


func _on_Area2D_pressed(number):
	self.state = number
