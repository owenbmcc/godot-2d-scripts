"""
Portal script, triggers "Entered" animation, loads new level
load a level in Load Level Path

node setup
• Area2D #TriggerScene.gd (Portal)
	• AnimatedSprite2D
	~ AudioStreamPlayer2D (EnteredSound)

AnimateSprite2D animations: default/Idle (autoplay=true), Entered (loop=false)

signals
Area2D body_entered -> _on_body_entered
AnimatedSprite2D animation_finished -> _on_animation_finished
"""

extends Area2D

# on activation flip is_active and then play animation
var is_active = false

signal on_activate # signal to scene manager
var signal_sent = false # prevent sending signal multiple times

func _on_body_entered(_body):
	if not is_active:
		is_active = true
		$AnimatedSprite2D.play("Entered")

func _on_animation_finished():
	if is_active and not signal_sent:
		signal_sent = true
		emit_signal("on_activate")
