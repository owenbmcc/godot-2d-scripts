"""
# obstacle that hurts player when colliding
# option to remove

• Area2D #ObstacleStatic.gd (ObstacleName) (Layer: Enemy, Mask: Player)
	• Sprite2D/AnimatedSprite2D
	• CollisionShape2D
	• Timer (HitTimeout) (oneshot=true)
	~ AudioStreamPlayer2D (HitSound)
	~ StaticBody2D (if player should not pass through the obstacle)
		• CollisionShape2D

"""

extends Area2D

# remove sprite after collision
@export var remove_on_collision : bool = false

func _body_entered(body):
	
	if $HitTimeout.is_stopped():
		body.enemy_collision() # call enemy collision func in player
		if remove_on_collision:
			queue_free()
		$HitTimeout.start()
	
		# remove comment to play sfx
		# $HitSound.play()
