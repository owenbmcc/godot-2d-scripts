"""
track items, enemies, objects that should be removed from a scene
add to Autoload
Project > Project Settings > Globals > Autoload
"""

extends Node

# track all items and enemies ...
# only used to add and remove items from scenes at scene load
var scene_objects : Dictionary = {}

# track the current scene so we know if a new scene was started
var current_scene : String = "none"

func restart():
	current_scene = "none"
	scene_objects = {}
