"""
connect signal from event to sound effect
"""
extends AudioStreamPlayer2D

func _ready() -> void:
	# throws error if audio stream player is missing a file
	assert(stream, "missing stream (audio file), remove or add stream")

func play_sound(_name) -> void:
	play()
