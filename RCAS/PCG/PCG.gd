extends Node2D

signal feedbackloop

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

	# debug()

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
	
func emit_feedbackloop(anim_name: String):
	emit_signal("feedbackloop")

func warp_feedback():
	var node = warp_feed.instance() 
	add_child(node)
	node.get_node("AnimationPlayer").connect("animation_finished", self, "emit_feedbackloop")
	
func impl_feedback():
	var node = impl_feed.instance() 
	add_child(node)
	node.get_node("AnimationPlayer").connect("animation_finished", self, "emit_feedbackloop")

func phsr_feedback():
	var node = phsr_feed.instance() 
	add_child(node)
	node.get_node("AnimationPlayer").connect("animation_finished", self, "emit_feedbackloop")

func snsr_feedback():
	var node = snsr_feed.instance() 
	add_child(node)
	node.get_node("AnimationPlayer").connect("animation_finished", self, "emit_feedbackloop")

func dflc_feedback():
	var node = dflc_feed.instance() 
	add_child(node)
	node.get_node("AnimationPlayer").connect("animation_finished", self, "emit_feedbackloop")

func shld_feedback():
	var node = shld_feed.instance() 
	add_child(node)
	node.get_node("AnimationPlayer").connect("animation_finished", self, "emit_feedbackloop")

func holo_feedback():
	var node = holo_feed.instance() 
	add_child(node)
	node.get_node("AnimationPlayer").connect("animation_finished", self, "emit_feedbackloop")

func torp_feedback():
	var node = torp_feed.instance() 
	add_child(node)
	node.get_node("AnimationPlayer").connect("animation_finished", self, "emit_feedbackloop")

func tnsp_feedback():
	var node = tnsp_feed.instance() 
	add_child(node)
	node.get_node("AnimationPlayer").connect("animation_finished", self, "emit_feedbackloop")

