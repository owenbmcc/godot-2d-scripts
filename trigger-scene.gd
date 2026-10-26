"""
Portal script, triggers "Entered" animation, loads new level
load a level in Load Level Path

node setup
• Area2D #TriggerScene.gd (Portal)
	• AnimatedSprite2D
	~ AudioStreamPlayer2D (EnteredSound)

AnimateSprite2D animations: default/Idle (autoplay=true), Entered (loop=false)

signals
AnimatedSprite2D animation_finished -> _on_animation_finished
"""

extends Area2D

# pick scene/level to load
@export_file var load_level_path

# activate, then play animation, prevents multiple events
var is_entered : bool = false

# connect signal from portal Area2d
func _on_body_entered(_body):
	is_entered = true
	$AnimatedSprite2D.play("Entered")
	
	# remove comemnt to play sfx
	# $EnteredSound.play()

# connect singal from AnimatedSprite2D node
func _on_animation_finished():
	if is_entered:
		get_tree().change_scene_to_file(load_level_path)
