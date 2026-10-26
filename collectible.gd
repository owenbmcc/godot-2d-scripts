"""
any item that can be collected
ItemName should match property in Global.gd to track

node setup
• Area2D #Collectible.gd (ItemName ie Apple, Coin) (Layer: Collectible, Mask: Player)
	• AnimatedSprite2D
	• CollisionShape2D
	~ AudioStreamPlayer (CollectedSound)

signals
Area2D body_entered -> _on_body_entered
AnimatedSprite2D animation_finished() -> _on_animation_finished
on_collected -> ItemsManager _on_collectible_collected

AnimatedSprite2D animations Idle/default (autoplay=true), Collected (loop=false)
"""

extends Area2D

# item needs a name, can be tracked globally
@export var collectible_type : String

var is_collected : bool = false

# connect scenemanager for metrics ui 
# connect to item manager to track item state
signal on_collected

# when player enters trigger animation
# connect signal from Area2D, body entered
func _on_body_entered(_body):
	if not is_collected:
		is_collected = true
		$AnimatedSprite2D.play("Collected")
		$AnimatedSprite2D.frame = 0 # start at beginning
		emit_signal("on_collected", collectible_type)
		
		# remove for sfx
		# $CollectedSound.play()

# when animation finishes, remove collectible
# connect signal from AnimatedSprite animation finished
func _on_animation_finished():
	if is_collected:
		queue_free()
