"""
global script to save variables,
values, etc.
between scenes
add to Autoload, Project > Project Settings > Globals > Autoload
"""
extends Node

# save values that need to exist for multiple levels
# life and item are examples
var props : Dictionary = { "life" : 3, "item": 0 }

# values that need to be available to scene manager logic (for example)
var player_lives_max = 3

func restart():
	props = { "life" : 3, "item": 0 }
