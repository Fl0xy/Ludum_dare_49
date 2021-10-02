extends Node2D

var connected: bool setget changeConnected

signal deviceConnect(device)
signal deviceDisconnect()

func _ready():
	self.connected = false
	$Button.connect("pressed", self, "toggle")


func deviceDisconnect():
	self.connected = false

func toggle():
	changeConnected(!connected)

func changeConnected(newConnected: bool):
	connected = newConnected
	if (connected):
		$Button.text = "Disconnect"
		emit_signal("deviceConnect", self)
	else:
		$Button.text = "Connect"
		emit_signal("deviceDisconnect")
