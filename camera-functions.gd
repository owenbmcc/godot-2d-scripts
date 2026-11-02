"""
functions for player parented camera
"""

extends Camera2D

# snap to the new player position for respawn
func snap() -> void:
	self.reset_smoothing()
