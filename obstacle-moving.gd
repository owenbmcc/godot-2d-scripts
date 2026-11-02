"""
moving enemy, set up with enemy facing left
(optional) detect player to start moving
separate layers for each collider
enemy needs to be centered in scene for collisions, raycast to work correctly
rename main CollisionShape2D to Collider for Platform Checker to change directions on platform edge

node setup
• CharacterBody2D (enemy_name) #obstacle-moving.gd 
	[Layer: enemy, Mask: platforms, player]
	-> on_attack -> player die or hit
	-> on_death -> sfx, game manager
	
	• AnimatedSprite2D
		animations: walk, idle, death (loop=false), attack (loop=false)
	• Raycast2D 
		[Layer off, Mask: platforms]
	• CollisionShape2D
	• Area2D (attack) 
		[Layer: enemy_attack, Mask: player]
		• CollisionShape2D
		-> body_entered -> on_attack_body_entered
	• Area2D (hit_box) 
		[Layer: hit_box, Mask: player)
		• CollisionShape2D
		-> body_entered -> on_hit_box_body_entered
	• Area2D (player_detect) 
		[Layer: player_detect, Mask: player)
		• CollisionShape2D
		-> body_entered -> _on_detect_body_entered
	• Timer - oneshot=true
	~ AudioStreamPlayer2D death_sound
	~ AudioStreamPlayer2D hit_sound
"""

extends CharacterBody2D
class_name Obstacle

# editor settings
@export var is_moving : bool = true
@export var speed : int = 50
@export var stay_on_platform : bool = true
@export var direction : int = -1 # 1 for right, -1 for left
@export var activate_on_player_detect : bool = false # begins moving when player is within area

# member vars
var is_alive : bool = true
var horizontal_move : bool = true
var temp_speed : int = speed
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal on_attack
signal on_hit
signal on_death

# get the areas to mirror them
var areas: Array[Area2D] = []

func _ready() -> void:
	$AnimatedSprite2D.flip_h = direction == 1 # match animation to direction
	
	# move floor check in front of collider
	$RayCast2D.position.x = direction * $CollisionShape2D.shape.radius
	
	# stop movement if waiting for player detect
	if activate_on_player_detect:
		horizontal_move = false
	
	for child in get_children():
		if child is Area2D:
			areas.append(child)
		

func _physics_process(_delta) -> void:
	if is_moving and is_alive:
		movement_update()

func movement_update() -> void:
	if stay_on_platform:
		if is_on_wall() or not $RayCast2D.is_colliding():
			direction = direction * -1 # switch direction
			$AnimatedSprite2D.flip_h = direction == 1 # match animation to direction
			$RayCast2D.position.x = direction * $CollisionShape2D.shape.radius
			for area in areas:
				area.position.x = area.position.x * -1
				area.position.x = area.position.x * -1
	
	if not is_on_floor():
		velocity.y += gravity
	
	if is_on_floor() and horizontal_move:
		velocity.x = speed * direction
	
	move_and_slide()
	
	if abs(velocity.x) > 0.1:
		$AnimatedSprite2D.play("walk")

# hit by player or projectile
func hit() -> void:
	is_alive = false
	$AnimatedSprite2D.play("death")
	emit_signal("on_hit")
	emit_signal("on_death")

# if player jump on head or another part, hits with projectile
# connect body_entered signal from HitBox
func on_hit_body_entered(body) -> void:
	if body is not Player:
		return
	if is_alive:
		hit()

# area that harms/kills player
# connect body_entered signal from Attack
func on_attack_body_entered(body) -> void:
	if body is not Player:
		return
	if is_alive and $Timer.is_stopped():
		$AnimatedSprite2D.play("attack")
		is_moving = false # stop moving to attack player
		$Timer.start()
		emit_signal("on_attack")

# area that detect player is nearby
# connect body_entered signal from Detect
func on_detect_body_entered(body) -> void:
	if body is not Player:
		return
	if is_alive:
		if activate_on_player_detect:
			horizontal_move = true

# connect animation_finished signal from AnimatedSprite2D
func on_animation_finished():

	# if dead, remove object
	if not is_alive:
		queue_free()
		
	# resume moving after attack
	if $AnimatedSprite2D.animation == "attack":
		is_moving = true
