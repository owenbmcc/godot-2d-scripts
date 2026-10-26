"""
save position for player
saved globally bc scene restarts if player game overs

node setup
• Area2D #Checkpoint.gd (Checkpoint) (Layer: Checkpoints, Mask: Player)
	• AnimatedSprite2D
	• CollisionShape2D
	~ AudioStreamPlayer (ActivateSound)
		
signals
Area2D body_entered -> _on_body_entered
checkpoint_activated -> CheckPointManager _on_checkpoint_activated
	
AnimatedSprite2D animations default/Idle (autoplay=true), Entered (loop=false)
"""

extends Area2D

# boolean to prevent setting more than once
var is_active : bool = false
signal checkpoint_activated

func _on_body_entered(_body):
	if not is_active:
		is_active = true
		$AnimatedSprite2D.play("Entered")
		emit_signal("checkpoint_activated", position)
		
		# remove comment to play sfx
		# $ActivateSound.play()
