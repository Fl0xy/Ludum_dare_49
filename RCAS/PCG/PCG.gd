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
	
	$warp.connect("deviceConnect", self, "connect_lane_5")
	$impl.connect("deviceConnect", self, "connect_lane_6")
	$phsr.connect("deviceConnect", self, "connect_lane_7")
	$snsr.connect("deviceConnect", self, "connect_lane_8")
	$dflc.connect("deviceConnect", self, "connect_lane_9")
	$shld.connect("deviceConnect", self, "connect_lane_4")
	$holo.connect("deviceConnect", self, "connect_lane_3")
	$torp.connect("deviceConnect", self, "connect_lane_2")
	$tnsp.connect("deviceConnect", self, "connect_lane_1")
	
	$warp.connect("deviceDisconnect", self, "disconnect_lane_5")
	$impl.connect("deviceDisconnect", self, "disconnect_lane_6")
	$phsr.connect("deviceDisconnect", self, "disconnect_lane_7")
	$snsr.connect("deviceDisconnect", self, "disconnect_lane_8")
	$dflc.connect("deviceDisconnect", self, "disconnect_lane_9")
	$shld.connect("deviceDisconnect", self, "disconnect_lane_4")
	$holo.connect("deviceDisconnect", self, "disconnect_lane_3")
	$torp.connect("deviceDisconnect", self, "disconnect_lane_2")
	$tnsp.connect("deviceDisconnect", self, "disconnect_lane_1")

	# debug()


func connect_lane_5(device):
	$ui_lane_5_mask.modulate = Style.ON_COLOR
func connect_lane_6(device):
	$ui_lane_6_mask.modulate = Style.ON_COLOR
func connect_lane_7(device):
	$ui_lane_7_mask.modulate = Style.ON_COLOR
func connect_lane_8(device):
	$ui_lane_8_mask.modulate = Style.ON_COLOR
func connect_lane_9(device):
	$ui_lane_9_mask.modulate = Style.ON_COLOR
func connect_lane_4(device):
	$ui_lane_4_mask.modulate = Style.ON_COLOR
func connect_lane_3(device):
	$ui_lane_3_mask.modulate = Style.ON_COLOR
func connect_lane_2(device):
	$ui_lane_2_mask.modulate = Style.ON_COLOR
func connect_lane_1(device):
	$ui_lane_1_mask.modulate = Style.ON_COLOR


func disconnect_lane_5(device):
	$ui_lane_5_mask.modulate = Style.OFF_COLOR
func disconnect_lane_6(device):
	$ui_lane_6_mask.modulate = Style.OFF_COLOR
func disconnect_lane_7(device):
	$ui_lane_7_mask.modulate = Style.OFF_COLOR
func disconnect_lane_8(device):
	$ui_lane_8_mask.modulate = Style.OFF_COLOR
func disconnect_lane_9(device):
	$ui_lane_9_mask.modulate = Style.OFF_COLOR
func disconnect_lane_4(device):
	$ui_lane_4_mask.modulate = Style.OFF_COLOR
func disconnect_lane_3(device):
	$ui_lane_3_mask.modulate = Style.OFF_COLOR
func disconnect_lane_2(device):
	$ui_lane_2_mask.modulate = Style.OFF_COLOR
func disconnect_lane_1(device):
	$ui_lane_1_mask.modulate = Style.OFF_COLOR




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

