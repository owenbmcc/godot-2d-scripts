"""
track checkpoints in scene
saves the spawn_position and info between scenes
Add to Autoload scripts, Project > Project Settings > Globals > Autoload
"""

extends Node

# save a spawn position where character starts
var spawn_position : Vector2 = Vector2.ZERO

# track the current scene so we know if a new scene was started
var current_scene : String = "none"

# spawn position changed by check points
func update_spawn_position(position):
	spawn_position = position

func restart():
	current_scene = "none"
	spawn_position = Vector2.ZERO
