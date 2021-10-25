tool
extends Node2D

signal pressed

export var bar_length: int = 72 setget set_bar_length
export var text: String = "Text" setget set_text

export var base_color: Color = Color8(255,255,255)
export var highlight_color: Color = Color8(100,100,100)

export var disabled = false setget set_disabled

func set_disabled(v: bool):
	disabled = v
	if v:
		highlight()
	else:
		dehighlight()

func set_text(v):
	text = v
	$bar/Label.text = v

func set_bar_length(v):
	bar_length = v
	$bar.region_rect.size.x = v
	$bar/circle_29_.position.x = v
	$Area2D.position.x = ($circle_29_.position.x + $bar.position.x + $bar/circle_29_.position.x + $bar/circle_29_.region_rect.size.x) / 2.0
	$Area2D/CollisionShape2D.shape.height = 11 + v

func _ready():
	$Area2D.connect("click_released", self, "press")
	$Area2D.connect("input_event", self, "on_hover")
	$Area2D.connect("mouse_exited", self, "on_mouse_exited")
	
	self.disabled = disabled # this is just here, to force the button to color itself
	
	# the following is not optimal
	#var shape: CapsuleShape2D
	#shape.height = $Area2D/CollisionShape2D.shape.height
	#shape.radius = $Area2D/CollisionShape2D.shape.radius
	
func on_mouse_exited():
	if disabled:
		return
	dehighlight()

func on_hover(viewport, event: InputEvent, shape_idx):
	if disabled:
		return
	if event is InputEventMouse:
		if (event.button_mask & BUTTON_LEFT) != 0:
			highlight()

func press():
	if disabled:
		return
	emit_signal("pressed")
	dehighlight()
	# print("pressed")#debug

func highlight():
	modulate = highlight_color

func dehighlight():
	modulate = base_color


