"""
any item that can be collected
collectible_name will be tracked in global.gd (if it exists)

node setup
• Area2D # collectible.gd (collectible_name ie coin, special_key) 
	[Layer: collectible, Mask: player]
	-> body_entered -> _on_body_entered
	-> on_collected -> item_manager _on_collectible_collected

	• AnimatedSprite2D
		animations: idle/default (autoplay=true), collected (loop=false)
		-> animation_finished() -> _on_animation_finished
	• CollisionShape2D
	~ AudioStreamPlayer # play_sfx.gd
"""

extends Area2D

## item needs a name, can be tracked globally
@export var collectible_name : String = "coin"

## send to item-manager, hud, etc
signal on_collected(collectible_name: String)

# prevent collection after first collision
var is_collected : bool = false
var has_anim : bool = false

func _ready() -> void:
	if has_node("AnimatedSprite2D"):
		assert($AnimatedSprite2D.sprite_frames.has_animation("collected"), "AnimatedSprite2D requires collected animation")
		has_anim = true
		$AnimatedSprite2D.sprite_frames.set_animation_loop("collected", false)

# when player enters trigger animation
# connect signal from Area2D, body entered
func _on_body_entered(_body) -> void:
	if is_collected:
		return
	is_collected = true
	emit_signal("on_collected", collectible_name)
	if has_anim:
		$AnimatedSprite2D.play("collected")
		$AnimatedSprite2D.frame = 0 # start at beginning
	else:
		queue_free()

# when animation finishes, remove collectible
# connect signal from AnimatedSprite animation finished
func _on_animation_finished():
	if is_collected:
		queue_free()
