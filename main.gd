extends Node2D

func _ready():
	
	$mmonitor/mac/antiMatterControl.connect("valueChanged", $warpCore, "changeInAntiMatterFlow")
	$mmonitor/mac/matterControl.connect("valueChanged", $warpCore, "changeInMatterFlow")
	
	$warpCore.connect("outputPlasmaChanged", $mmonitor/mac/mamChart, "changeInPlasma")
	$warpCore.connect("outputPowerChanged", $mmonitor/mac/powChart, "changeInPower")
	
	$mmonitor/pcg/warp.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/warp.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/impl.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/impl.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/phsr.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/phsr.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/snsr.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/snsr.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/dflc.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/dflc.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/shld.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/shld.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/holo.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/holo.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/torp.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/torp.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	$mmonitor/pcg/tnsp.connect("deviceConnect", $warpCore, "connectDevice")
	$mmonitor/pcg/tnsp.connect("deviceDisconnect", $warpCore, "disconnectDevice")
	
	

func makeKaputt():
	$warpCore.changeHealth($warpCore.health - 0.1)
