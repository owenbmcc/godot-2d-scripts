
"""
emits projectiles
add to player or enemy

add "Projectile" to Input Map
Project > Project Settings > Input Map

projectile scene is PackedScene, not part of the hierarchy

node setup
• Player
	• Node2D #ProjectileEmitter.gd (ProjectileEmitter)

signals
on_projectile -> Player _on_projectile
"""
extends Node2D

# load projectile scene here
@export var projectile : PackedScene

@export var projectile_toward_mouse : bool = false
@export var projectile_gravity : bool = false
@export var use_input : bool = true

var direction = 1 # 1 is right, -1 left

signal on_projectile

func _unhandled_input(_event: InputEvent) -> void:
	if not use_input:
		return
	if Input.is_action_just_pressed("Projectile"):
		await get_tree().process_frame
		spawn_projectile()

func spawn_projectile():
	var p = projectile.instantiate()
	owner.add_child(p)
	# set direction of projectile in player direction
	p.position.x = self.position.x
	p.position.y = self.position.y
	var d = direction
	if not use_input:
		d = get_parent().direction
	p.set_direction(projectile_toward_mouse, d, projectile_gravity)
