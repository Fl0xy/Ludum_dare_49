extends Node2D

var warp_feed = preload("res://RCAS/feedback/warp_feedback.tscn")
var impl_feed = preload("res://RCAS/feedback/impl_feedback.tscn")
var phsr_feed = preload("res://RCAS/feedback/phsr_feedback.tscn")
var snsr_feed = preload("res://RCAS/feedback/snsr_feedback.tscn")
var dflc_feed = preload("res://RCAS/feedback/dflc_feedback.tscn")
var shld_feed = preload("res://RCAS/feedback/shld_feedback.tscn")
var holo_feed = preload("res://RCAS/feedback/holo_feedback.tscn")
var torp_feed = preload("res://RCAS/feedback/torp_feedback.tscn")
var tnsp_feed = preload("res://RCAS/feedback/tnsp_feedback.tscn")



func _ready():
	$warp.connect("feedbackloop", self, "warp_feedback")
	$impl.connect("feedbackloop", self, "impl_feedback")
	$phsr.connect("feedbackloop", self, "phsr_feedback")
	$snsr.connect("feedbackloop", self, "snsr_feedback")
	$dflc.connect("feedbackloop", self, "dflc_feedback")
	$shld.connect("feedbackloop", self, "shld_feedback")
	$holo.connect("feedbackloop", self, "holo_feedback")
	$torp.connect("feedbackloop", self, "torp_feedback")
	$tnsp.connect("feedbackloop", self, "tnsp_feedback")

	debug()

func debug():
	warp_feedback()
	impl_feedback()
	phsr_feedback()
	snsr_feedback()
	dflc_feedback()
	shld_feedback()
	holo_feedback()
	torp_feedback()
	tnsp_feedback()
	

func warp_feedback():
	add_child(warp_feed.instance())

func impl_feedback():
	add_child(impl_feed.instance())

func phsr_feedback():
	add_child(phsr_feed.instance())

func snsr_feedback():
	add_child(snsr_feed.instance())

func dflc_feedback():
	add_child(dflc_feed.instance())

func shld_feedback():
	add_child(shld_feed.instance())

func holo_feedback():
	add_child(holo_feed.instance())

func torp_feedback():
	add_child(torp_feed.instance())

func tnsp_feedback():
	add_child(tnsp_feed.instance())

