extends Sprite

var generator_ui_feedback = preload("res://RCAS/feedback/generator_ui_feedback.tscn")

func _ready():
	$pcg.connect("feedbackloop", self, "spawn_generator_feedbackloop")

func spawn_generator_feedbackloop():
	var node = generator_ui_feedback.instance()
	add_child(node)
	node.get_node("AnimationPlayer").connect("animation_finished", self, "damage_generator")

func damage_generator(anim_name: String): # weil flo grade in der main ist, nicht über signals
	get_parent().makeKaputt()
