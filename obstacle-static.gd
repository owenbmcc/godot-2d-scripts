"""
obstacle that hurts/kills player when colliding

• Area2D #obstacle-static.gd
	[Layer: obstacle, Mask: player]
	• Sprite2D/AnimatedSprite2D
	• CollisionShape2D
	• Timer (oneshot=true)
	~ AudioStreamPlayer2D
	~ StaticBody2D (if player should not pass through the obstacle)
		• CollisionShape2D

"""

extends Area2D

## remove sprite after collision
@export var remove_on_collision : bool = false
signal on_collision

func _ready() -> void:
	assert(has_node("Timer"), "add a Timer node for hit timeout")
	$Timer.one_shot = true

func on_body_entered(body) -> void:
	if body is not Player:
		return
	if $Timer.is_stopped():
		emit_signal("on_collision")
		$Timer.start()
		if remove_on_collision:
			queue_free()
