"""
basic moving enemy, set up with enemy facing left
dies on player hit
attack player in attack box, deals damage
(optional) detect player to start moving
separate layers for each collider
Death and Attack animations No Loop
enemy needs to be centered in scene for collisions, raycast to work correctly
rename main CollisionShade2D to Collider for Platform Checker to change directions on platform edge

calls enemy_collision on player

node setup
• CharacterBody2D #ObstacleMoving.gd (EnemyName) (Layer: Enemy, Mask: Platforms, ~Player)
	• AnimatedSprite2D
	• Raycast2D (PlatformChecker) (Layer off, Mask: Tiles/Platforms)
	• CollisionShape2D (Collider)
	• Area2D (Attack) (Layer: Attack, Mask: Player)
		• CollisionShape2D
	• Area2D (HitBox) (Layer: HitBox, Mask: Player)
		• CollisionShape2D
	• Area2D (Detect) (Layer: Detect, Mask: Player)
		• CollisionShape2D
	• Timer (HitTimeout) (Oneshot=true)
	~ AudioStreamPlayer2D (DeathSound)
	~ AudioStreamPlayer2D (HitSound)

AnimatedSprite2D animations: Walk, Idle, Death (loop=false), Attack (loop=false)

signals
Area2D (Attack) body_entered -> _on_Attack_body_entered
Area2D (Detect) body_entered -> _on_Detect_body_entered
Area2D (HitBox) body_entered -> _on_HitBox_body_entered
"""

extends CharacterBody2D

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

func _ready():
	$AnimatedSprite2D.flip_h = direction == 1 # match animation to direction
	
	# move floor check in front of collider
	$PlatformChecker.position.x = direction * $Collider.shape.radius
	
	# stop movement if waiting for player detect
	if activate_on_player_detect:
		horizontal_move = false

func _physics_process(_delta):
	if is_moving and is_alive:
		movement_update()

func movement_update():
	if stay_on_platform:
		if is_on_wall() or not $PlatformChecker.is_colliding():
			direction = direction * -1 # switch direction
			$AnimatedSprite2D.flip_h = direction == 1 # match animation to direction
			$PlatformChecker.position.x = direction * $Collider.shape.radius
			$HitBox.position.x = $HitBox.position.x * -1
			$Attack.position.x = $Attack.position.x * -1
	
	if not is_on_floor():
		velocity.y += gravity
	
	if is_on_floor() and horizontal_move:
		velocity.x = speed * direction
	
	move_and_slide()
	
	if abs(velocity.x) > 0.1:
		$AnimatedSprite2D.play("Walk")

# hit by player or projectile
func hit():
	is_alive = false
	$AnimatedSprite2D.play("Death")
	
	# remove comment to play sfx
	# $DeathSound.play()

# if player jump on head or another part, hits with projectile
# connect body_entered signal from HitBox
func _on_HitBox_body_entered(_body):
	if is_alive:
		hit()

# area that harms/kills player
# connect body_entered signal from Attack
func _on_Attack_body_entered(body):
	
	if is_alive and body.is_alive and $HitTimeout.is_stopped():
		$AnimatedSprite2D.play("Attack")
		is_moving = false # stop moving to attack player
		body.enemy_collision() # call enemy collision func in player
		$HitTimeout.start()
		
		# remove comment to play sfx
		# $HitSound.play()

# area that detect player is nearby
# connect body_entered signal from Detect
func _on_Detect_body_entered(_body):
	if is_alive:
		if activate_on_player_detect:
			horizontal_move = true

# connect animation_finished signal from AnimatedSprite2D
func _on_animation_finished():
	
	# if dead, remove object
	if not is_alive:
		queue_free()
		
	# resume moving after attack
	if $AnimatedSprite2D.animation == "Attack":
		is_moving = true
