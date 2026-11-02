"""
save position for player
saved globally bc scene restarts if player game overs

node setup
• Area2D (checkpoint) #checkpoint.gd 
	[Layer: Checkpoints, Mask: Player]
	-> body_entered -> on_body_entered
	-> on_activated -> checkpoint-manager
	• CollisionShape2D
	• AnimatedSprite2D
		animations: default/idle (autoplay=true), activated (loop=false)
	~ AudioStreamPlayer
"""

extends Area2D

# boolean to prevent setting more than once
var is_activated : bool = false
signal on_activated(position: Vector2)
var has_anim : bool = false

func _ready() -> void:
	if has_node("AnimatedSprite2D"):
		assert($AnimatedSprite2D.sprite_frames.has_animation("activated"), "AnimatedSprite2D requires activated animation")
		has_anim = true
		$AnimatedSprite2D.sprite_frames.set_animation_loop("activated", false)

func on_body_entered(_body):
	if is_activated:
		return
	is_activated = true
	emit_signal("on_activated", position)
	if has_anim:
		$AnimatedSprite2D.play("activated")
