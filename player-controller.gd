"""
simple 2d player controller
set up with player art facing right

• CharacterBody2D #PlayerController.gd (Player)
	• AnimatedSprite2D
	• CollisionShape2D
	~ ProjectileEmitter
	~ AudioStreamPlayer2D (JumpSound)
	~ AudioStreamPlayer2D (LandSound)
	~ AudioStreamPlayer2D (DeathSound)

PlayerController uses the following inputs:
	move_up, move_down, move_right, move_left, jump, projectile
These are defined in Project > Project Settings > Input Map

AnimatedSprite2D animations: idle, walk, jump, projectile, hit, death, talk 

signals
player_fall -> SceneManager _on_player_fall
player_hit -> SceneManager _on_player_hit
AnimatedSprite2D animation_finished -> _on_animation_finished
ProjectileEmitter on_projective -> _on_projectile

"""

extends CharacterBody2D
class_name Player

# physics settings for player
@export var speed : int = 100
@export var use_slide : bool = false
@export var friction : int = 600
@export var use_gravity : bool = false
@export var jump_force : int = 400
@export var double_jump : bool = false
@export var use_wall_jump : bool = false
@export var y_limit : int = 0
@export var use_projectile : bool = false

# member vars 
var input_vector : Vector2 = Vector2.ZERO
var is_moving : bool = true
var is_alive : bool = true # to allow scene to run without character updating
#var velocity : Vector2 = Vector2()
var is_jumping : bool = false # track if jumping for landing sound
var jump_count : int = 0
var projectile_pause : bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal player_hit # signal if player is hit by obstacle
signal player_fall # player goes beneath game window

func _ready():
	if not is_on_floor():
		is_jumping = true
	if y_limit == 0:
		y_limit = get_viewport().size.y * 2

func _unhandled_input(_event: InputEvent) -> void:
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")

# this function will run every time the game engine updates physics
func _physics_process(delta):
	if is_alive:
		if is_moving:
			movement_update(delta)
	update_animation()

func movement_update(delta):
#	velocity.x = 0 # start by assuming player is not moving
	
	# capture user input

	if input_vector.x:
		velocity.x = input_vector.x * speed
	elif use_slide:
		if velocity.length() > (friction * delta):
			velocity.x -= velocity.normalized().x * (friction * delta)
		else:
			velocity.x = 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if not use_gravity:
		if input_vector.y:
			velocity.y = input_vector.y * speed
		elif use_slide:
			if velocity.length() > (friction * delta):
				velocity.y -= velocity.normalized().y * (friction * delta)
			else:
				velocity.y = 0
		else:
			velocity.y = move_toward(velocity.y, 0, speed)

	# move player
	move_and_slide()
	
	if not use_gravity:
		return
		
	# apply gravity to player
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# detect landing before jump starts
	if is_jumping and (is_on_floor() or is_on_wall()):
		is_jumping = false
		jump_count = 0
		# remove comments to play sfx
		# $LandSound.play()
	
	# jump input
	var can_jump = is_on_floor() or (use_wall_jump and is_on_wall())
	if double_jump and jump_count < 2:
		if not can_jump:
			can_jump = true
	
	if Input.is_action_just_pressed("jump") and can_jump:
		jump_count = jump_count + 1
		if jump_count > 0:
			velocity.y = 0
		velocity.y -= jump_force
		is_jumping = true
		$AnimatedSprite2D.frame = 0
		# remove comments to play sfx
		# $JumpSound.play()
		
	# if player falls below screen
	if is_alive and position.y > y_limit:
		emit_signal("player_fall") # to scene manager
	
func update_animation():
	if not is_on_floor() and is_moving and use_gravity:
		$AnimatedSprite2D.play("jump")
	elif velocity.length_squared() > 1 and is_moving:
		$AnimatedSprite2D.play("walk")
	elif is_moving:
		$AnimatedSprite2D.play("idle")

	# change sprite direction
	if velocity.x < -1:
		$AnimatedSprite2D.flip_h = true
		if use_projectile:
			$ProjectileEmitter.direction = -1
	if velocity.x > 1:
		$AnimatedSprite2D.flip_h = false
		if use_projectile:
			$ProjectileEmitter.direction = 1

func enemy_collision():
	is_moving = false # player movement suspended before determining state
	$AnimatedSprite2D.play("hit")
	emit_signal("player_hit")

# after hit animation, test if player is still alive
func _on_animation_finished():
	# reset animation
	var a = $AnimatedSprite2D.animation
	if  a == "projectile" or a == "hit":
		is_moving = true

# called by scene manager if player out of lives
func die():
	is_alive = false
	$AnimatedSprite2D.play("death")
	# remove comment to play sfx
	# $DeathSound.play()

func talk():
	$AnimateSprite2D.play("talk")
	is_moving = false
	
func _on_projectile():
	$AnimatedSprite2D.play("projectile")
	if is_on_floor():
		is_moving = false
