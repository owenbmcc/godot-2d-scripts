"""
change the position of an object
use for player respawn, checkpoints, teleporting objects etc.
connect event signal -> on_change
"""
extends Marker2D

## object to change position
@export var object : Node

# event to connect signal
func trigger_change() -> void:
	object.position = position

# change the spawn position
func update_position(new_position) -> void:
	position = new_position
