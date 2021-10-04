tool
extends Sprite

enum modeEnum {matter, anitmatter}
export(int) var number: int
signal pressed(number)

func _ready():
	$Area2D.connect("input_event", self, "_on_Area2D_input_event")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		emit_signal("pressed", self.number)

func changeState(state: int, mode ):
	if (state < number):
		modulate = Style.DARKBLUE_COLOR
	else:
		if (mode == modeEnum.anitmatter):
			modulate = Style.ANTIMATTER_COLOR
		else:
			modulate = Style.MATTER_COLOR
