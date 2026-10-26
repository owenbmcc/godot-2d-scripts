"""
spawns player at saved checkpoints
add Node2D to scene using checkpoints
requires CheckpointsGlobal to be added to Autoload
Project > Project Settings > Globals > Autoload

add to Node in Level or Scene
nodes
• Level 1
	• Node #CheckpointsManager.gd (CheckpointsManager)

connect signals from checkpoints -> _on_checkpoint_activated
"""

extends Node

# get current scene name, needed to track items, checkpoints
@export var scene_name : String

# get reference to player to set position
@export var player : Node2D

# reference to global script to avoid errors
var checkpoints_global_ref : Node 

func _ready():
	# check for CheckpointsGlobal in Autoload
	checkpoints_global_ref = get_node_or_null("/root/CheckpointsGlobal")
	if checkpoints_global_ref == null:
		print("Setup error: CheckpointsGlobal must be added to Autoload")
		return
	
	if player == null:
		print("Setup error: Add player to CheckpointManager node")
		return

	# checkpoints -- get scene name from var or parent node name
	if scene_name.length() == 0:
		scene_name = get_parent().name
	
	# if this is a new scene, update the player position
	if scene_name != checkpoints_global_ref.current_scene:
		checkpoints_global_ref.current_scene = scene_name
		checkpoints_global_ref.update_spawn_position(player.position)
		
	# set the player to the current spawn position to keep up with checkpoints
	player.position = checkpoints_global_ref.spawn_position

func _on_checkpoint_activated(checkpoint_position):
	checkpoints_global_ref.update_spawn_position(checkpoint_position)
