extends Node2D

signal eject_core

var minimized : bool = false

export var SequenceButtonPressTimeUntilNext : float = 3.0
onready var sequence_button_press_time_remaining_until_next : float = SequenceButtonPressTimeUntilNext
var sequence_started = false
export var TimeUntilSequenceResets : float = SequenceButtonPressTimeUntilNext * 11 # time for all 10 seq and the eject button
onready var remaining_time_until_sequence_resets = TimeUntilSequenceResets
export var TimeUntilSequenceResetsAfterCompletingTheSequence : float = TimeUntilSequenceResets
var current_active_sequence_button : Node
var ejection_started = false


onready var toggle = $"ces_monitor/Buttons/ToggleButton"
onready var toggle_border = $"ces_monitor/Buttons/ToggleButton/ces_toggle-button_border"
onready var toggle_inner = $"ces_monitor/Buttons/ToggleButton/ces_toggle-button_inner"

var debug_count = 0;
func debug():
	print(debug_count, " : clicked")
	debug_count += 1

func toggle_minimize():
	toggle_border.modulate = toggle.OnColor
	toggle_inner.modulate = toggle.OffColor
	
	if minimized:
		$AnimationPlayer.play("move_up")
	else:
		$AnimationPlayer.play("move_down")
	
	minimized = not minimized

func reset_toggle_button(anim_name: String = ""):
	if anim_name == "" or anim_name == "move_up" or anim_name == "move_down":
		toggle_inner.modulate = toggle.OnColor
		toggle_border.modulate = toggle.OffColor

func _ready():
	# EJECT
	$"ces_monitor/Buttons/EjectionButton".connect("pressed", self, "eject")
	# TOGGLE
	$"ces_monitor/Buttons/ToggleButton/Area2D".connect("clicked", self, "toggle_minimize")
	$AnimationPlayer.connect("animation_finished", self, "reset_toggle_button")
	# SEQUENCE
	$"ces_monitor/Buttons/SequenceButtons/SequenceButton_0".connect("pressed", self, "on_sequence_button_pressed")
	$"ces_monitor/Buttons/SequenceButtons/SequenceButton_1".connect("pressed", self, "on_sequence_button_pressed")
	$"ces_monitor/Buttons/SequenceButtons/SequenceButton_2".connect("pressed", self, "on_sequence_button_pressed")
	$"ces_monitor/Buttons/SequenceButtons/SequenceButton_3".connect("pressed", self, "on_sequence_button_pressed")
	$"ces_monitor/Buttons/SequenceButtons/SequenceButton_4".connect("pressed", self, "on_sequence_button_pressed")
	$"ces_monitor/Buttons/SequenceButtons/SequenceButton_5".connect("pressed", self, "on_sequence_button_pressed")
	$"ces_monitor/Buttons/SequenceButtons/SequenceButton_6".connect("pressed", self, "on_sequence_button_pressed")
	$"ces_monitor/Buttons/SequenceButtons/SequenceButton_7".connect("pressed", self, "on_sequence_button_pressed")
	$"ces_monitor/Buttons/SequenceButtons/SequenceButton_8".connect("pressed", self, "on_sequence_button_pressed")
	$"ces_monitor/Buttons/SequenceButtons/SequenceButton_9".connect("pressed", self, "on_sequence_button_pressed")
	
	
	current_active_sequence_button = $"ces_monitor/Buttons/SequenceButtons/SequenceButton_0"
	current_active_sequence_button.inner_on()
	
	reset_toggle_button()

func eject():
	ejection_started = true
	emit_signal("eject_core")
	# TODO: possibly start an animation on these controls?

func on_sequence_button_pressed():
	sequence_started = true # well everytime but what gives \(lol)/
	switch_active_sequence_button()

func choose_random_inactive_pressable_sequence_button():
	var count = $"ces_monitor/Buttons/SequenceButtons".get_child_count()
	var rand = randi()
	for i in count:
		var button = $"ces_monitor/Buttons/SequenceButtons".get_children()[posmod(rand + i, count)]
		if not (button.is_border_on() or button.is_inner_on()):
			return button
	if not current_active_sequence_button.is_border_on(): # hack
		return current_active_sequence_button
	return null

func switch_active_sequence_button():
	sequence_button_press_time_remaining_until_next = SequenceButtonPressTimeUntilNext
	var button = choose_random_inactive_pressable_sequence_button()
	if button != null:
		current_active_sequence_button.inner_off()
		button.inner_on() # this makes the button pressable
		current_active_sequence_button = button
	else:
		if not $ces_monitor/Buttons/EjectionButton.is_inner_on():
			# then all sequence buttons are pressed. unlock the ejection button!
			remaining_time_until_sequence_resets = max(remaining_time_until_sequence_resets ,TimeUntilSequenceResetsAfterCompletingTheSequence)
			$ces_monitor/Buttons/EjectionButton.inner_on() # this makes the button pressable

func reset_button_sequence():
	sequence_started = false
	for c in $"ces_monitor/Buttons/SequenceButtons/".get_children():
		c.all_off()
	$"ces_monitor/Buttons/EjectionButton".all_off()
	switch_active_sequence_button()

func _physics_process(delta):
	if not ejection_started:
		if sequence_started:
			remaining_time_until_sequence_resets -= delta
			if remaining_time_until_sequence_resets <= 0:
				remaining_time_until_sequence_resets = TimeUntilSequenceResets
				reset_button_sequence()
				
		sequence_button_press_time_remaining_until_next -= delta
		if sequence_button_press_time_remaining_until_next <= 0:
			switch_active_sequence_button()
		
