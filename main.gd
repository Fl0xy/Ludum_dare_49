extends Node2D



func _ready():
	$matterControl.connect("valueChanged", $warpCore, "changeInMatterFlow")
	$antiMatterControl.connect("valueChanged", $warpCore, "changeInAntiMatterFlow")
	$device.connect("deviceConnect", $warpCore, "connectDevice")
	
	$warpCore.connect("outputPowerChanged", $powerHBar, "changeValue")
	$warpCore.connect("heatChanged", $TmpHBar, "changeValue")
	$warpCore.connect("outputPlasmaChanged", $plasmaMix, "changeValue")
