"""
change the position of an object
use for player respawn, checkpoints, teleporting objects etc.
connect event signal -> on_change
"""
extends Node

# object to change position
@export var object : Node

# marker for position to set 
@export var marker : Marker2D

# event to connect signal
func on_change():
	object.position = marker.position

# change the spawn position
func update_position(position):
	marker.position = position
