extends Node2D



func _ready():
	$matterControl.connect("valueChanged", $warpCore, "changeInMatterFlow")
	$antiMatterControl.connect("valueChanged", $warpCore, "changeInAntiMatterFlow")
	
	$warpCore.connect("outputPowerChanged", $powerHBar, "changeValue")
	$warpCore.connect("outputPlasmaChanged", $plasmaMix, "changeValue")
	
	$device.connect("deviceConnect", $warpCore, "connectDevice")
	$device.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$device.connect("feedbackloop", self, "makeKaputt")
	$device2.connect("deviceConnect", $warpCore, "connectDevice")
	$device2.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$device2.connect("feedbackloop", self, "makeKaputt")

func makeKaputt():
	$warpCore.changeHealth($warpCore.health - 0.1)
