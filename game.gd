extends Node2D

var game : PackedScene = preload("res://main.tscn")
var game_node = null

func _ready():
	$startmenu/play_game.connect("pressed", self, "start_game_without_tutorial")
	$startmenu/play_tutorial.connect("pressed", self, "start_game_with_tutorial")
	$startmenu/exit.connect("pressed", self, "quit_game")
	$startmenu/CheckBox.connect("toggled", self, "toggle_play_game_button")
	
	$endmenu/mainmenu.connect("pressed", self, "return_to_mainmenu")
	$endmenu/retry.connect("pressed", self, "retry")

func toggle_play_game_button(active: bool):
	$startmenu/play_game.disabled = !active

func quit_game():
	get_tree().quit()

func start_game_with_tutorial():
	start_game(true)

func start_game_without_tutorial():
	start_game(false)

func retry():
	$endmenu.visible = false
	start_game(false)

func return_to_mainmenu():
	game_node.visible = false
	$endmenu.visible = false
	$startmenu.visible = true

func start_game(tutorial: bool):
	$startmenu/CheckBox.pressed = true
	
	if game_node != null:
		game_node.queue_free() # Question: does this also disconnect the signals? prob
		game_node = null
	
	game_node = game.instance()
	game_node.get_node("tutorial").enable = tutorial
	game_node.connect("core_ejected", self, "show_core_ejected_endscreen")
	game_node.connect("core_exploded", self, "show_core_exploded_endscreen")
	add_child_below_node($Node, game_node)
	$startmenu.visible = false


func show_core_ejected_endscreen(play_time):
	print("show core ejected endscreen") #debug
	$endmenu.visible = true
	$endmenu/HBoxContainer/time.text = str(stepify(play_time, 0.01))


func show_core_exploded_endscreen(play_time):
	print("show core exploded endscreen") #debug
	$endmenu.visible = true
	$endmenu/HBoxContainer/time.text = str(stepify(play_time, 0.01))


var line_count = 0
func test():
	line_count += 1
	print(line_count, ": lol")
