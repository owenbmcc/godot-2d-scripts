"""
added in each scene to connect events to ui and game logic
logic for things like player deaths etc.
lots of options, so read through code

node setup
• Level 1
	• Node #SceneManager.gd (SceneManager)

options to open a UI or change the scene on game over
update metrics
requires Global.gd in Autoload to track metrics
"""

extends Node

# get reference to player to set position
@export var player : Node2D
@export var metrics_ui : Control

# references to scene path to change scene
@export_file var game_over_scene
@export_file var win_game_scene

# references to node, to load in scene
# add in UI canvas layer
@export var game_over_ui : Control
@export var win_game_ui : Control

# reference to global script to avoid errors
var global_ref : Node 

func _ready():
	
	global_ref = get_node_or_null("/root/Global")
	if global_ref == null:
		print("Setup error: ItemsGlobal must be added to Autoload")
		return
	
	# hide uis if they exist
	if game_over_ui:
		game_over_ui.visible = false
	if win_game_ui:
		win_game_ui.visible = false

func _on_player_hit():
	lose_life()
	var is_alive = calc_lives()
	if not is_alive:
		_on_player_died()
	metrics_ui.update()
	
func _on_player_fall():
	lose_life()
	var is_alive = calc_lives()

	if is_alive:
		get_tree().reload_current_scene()
	else:
		_on_player_died()
	
func lose_life():
	if global_ref.props["life"] > 0:
		global_ref.props["life"] = global_ref.props["life"] - 1

func calc_lives():
	return global_ref.props["life"] > 0

func _on_player_died():
	player.die()
	global_ref.restart()
	# ItemsGlobal.restart()
	# CheckpointsGlobal.restart()
	
	# change to game over scene
	get_tree().change_scene_to_file(game_over_scene)
	
	# or load ui in scene
	# if game_over_ui:
		# game_over_ui.visible = true

# some items just count up, others have specific conditions
func _on_item_collected(item_type):
	if item_type == "life":
		if global_ref.props["life"] < global_ref.player_lives_max:
			global_ref.props["life"] = global_ref.props["life"] + 1
	else:
		if not global_ref.props.has(item_type):
			global_ref.props[item_type] = 0
		global_ref.props[item_type] = global_ref.props[item_type] + 1
	metrics_ui.update()

func _on_NPC_update_metrics():
	metrics_ui.update()

func _on_win_game():
	# change scenes:
	# get_tree().change_scene_to_file(win_game_scene)
	
	# or load ui in scene
	if win_game_ui:
		win_game_ui.visible = true
