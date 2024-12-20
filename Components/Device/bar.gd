tool
extends Node2D

const BARLENGTH = 22
const BARHEIGHT = 3

enum modeState {energy, matter, anitmatter, off}
export(modeState) var mode = modeState.off setget setMode
export(bool) var on = false setget setOn
export(float) var blink_time_slow = 1
export(float) var blink_time_fast = 0.5
export(float) var value = 50 setget setValue
export(float) var maxValue = 100
export(bool) var rotate = false setget setRotate
export(bool) var discarge = false setget setDiscarge
var discarge_state: int = 0
var discard_timer: float = 1
var blink_timer
var blink: = false
var blink_fast = false
var blink_state = false

func _ready():
	pass

func _physics_process(delta):
	if (blink):
		if (blink_timer <= 0):
			if (blink_state):
				$ui_device_energy_bar.modulate = Style.DARKRED_COLOR
				$ui_device_excess_bar.modulate = Style.DARKRED_COLOR
				blink_state = false
			else:
				if (on):
					$ui_device_energy_bar.modulate = Style.ON_COLOR
					$ui_device_excess_bar.modulate = Style.ON_COLOR
				else:
					$ui_device_energy_bar.modulate = Style.OFF_COLOR
					$ui_device_excess_bar.modulate = Style.OFF_COLOR
				blink_state = true
				
			if (blink_fast):
				blink_timer = blink_time_fast
			else:
				blink_timer = blink_time_slow
		else:
			blink_timer -= delta
	if (discarge):
		if (discard_timer <= 0):
			discard_timer = 1
			if(discarge_state < 2):
				$ui_device_discarge_bar.region_rect.position.x = discarge_state
				discarge_state += 1
			else:
				$ui_device_discarge_bar.region_rect.position.x = 2
				discarge_state = 0
		else:
			discard_timer -= delta
	
func reset_blink():
	blink_state = true
	if (blink_fast):
		blink_timer = blink_time_fast
	else:
		blink_timer = blink_time_slow

func setMode(newMode):
	mode = newMode
	match mode:
		modeState.energy:
			$ui_symbole_energy.visible = true
			$ui_device_energy_bar.visible = true
			$ui_symbole_matter.visible = false
			$ui_symbole_antim.visible = false
			$ui_device_excess_bar.visible = false
			$ui_device_excess_bar_off.visible = false
			$bar.visible = true
			$bar.modulate = Style.ENERGY_COLOR
			$ui_device_discarge_bar.modulate = Style.ENERGY_COLOR_DARK
		modeState.anitmatter:
			$ui_symbole_antim.visible = true
			$ui_device_excess_bar.visible = true
			$ui_symbole_energy.visible = false
			$ui_symbole_matter.visible = false
			$ui_device_energy_bar.visible = false
			$ui_device_excess_bar_off.visible = false
			$bar.visible = true
			$bar.modulate = Style.ANTIMATTER_COLOR
			$ui_device_discarge_bar.modulate = Style.ANTIMATTER_COLOR_DARK
		modeState.matter:
			$ui_symbole_matter.visible = true
			$ui_device_excess_bar.visible = true
			$ui_symbole_energy.visible = false
			$ui_symbole_antim.visible = false
			$ui_device_energy_bar.visible = false
			$ui_device_excess_bar_off.visible = false
			$bar.visible = true
			$bar.modulate = Style.MATTER_COLOR
			$ui_device_discarge_bar.modulate = Style.MATTER_COLOR_DARK
		modeState.off:
			$ui_device_excess_bar_off.visible = true
			$ui_symbole_matter.visible = false
			$ui_device_excess_bar.visible = false
			$ui_symbole_energy.visible = false
			$ui_symbole_antim.visible = false
			$ui_device_energy_bar.visible = false
			$bar.visible = false
	reset_blink()

func setOn(newOn):
	on = newOn
	if (on):
		$ui_device_energy_bar.modulate = Style.ON_COLOR
		$ui_device_excess_bar.modulate = Style.ON_COLOR
		$ui_device_excess_bar_off.modulate = Style.ON_COLOR
	else:
		$ui_device_energy_bar.modulate = Style.OFF_COLOR
		$ui_device_excess_bar.modulate = Style.OFF_COLOR
		$ui_device_excess_bar_off.modulate = Style.OFF_COLOR
	reset_blink()

func setValue(newValue):
	value = newValue
	var fill: float = value/maxValue
	var barSize = clamp(BARLENGTH*fill, 0, BARLENGTH)
	$bar.scale = Vector2(barSize, BARHEIGHT)
	$ui_device_discarge_bar.region_rect.size.x = barSize
	if (fill <= 0.2 || fill >= 0.8):
		self.blink = true
		if (fill <= 0.1 || fill >= 0.9):
			self.blink_fast = true
		else:
			self.blink_fast = false
	else:
		self.blink = false

func setBlink(newBlink):
	blink = newBlink
	reset_blink()
	
func setRotate(newRotate):
	rotate = newRotate
	if (rotate):
		$ui_device_excess_bar.scale = Vector2(1, -1)
		$ui_device_excess_bar.position = Vector2(0, 5)
		$ui_device_excess_bar_off.scale = Vector2(1, -1)
		$ui_device_excess_bar_off.position = Vector2(0, 5)
	else:
		$ui_device_excess_bar.scale = Vector2(1, 1)
		$ui_device_excess_bar.position = Vector2(0, 0)
		$ui_device_excess_bar_off.scale = Vector2(1, 1)
		$ui_device_excess_bar_off.position = Vector2(0, 0)
		
func setDiscarge(newDiscarge):
	discarge = newDiscarge
	if (discarge):
		$ui_device_discarge_bar.visible = true
	else:
		$ui_device_discarge_bar.visible = false
