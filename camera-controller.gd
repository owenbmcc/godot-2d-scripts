"""
use this if camerea cannot be parented to the player
this makes the camera follow the player 
node setup
• Level 1
	• Player
	• Camera2D #CameraController.gd
"""

extends Camera2D

# get reference to player to track/follow position
@export var player : Node2D

# track camera copies the player position as soon as player moves
@export var track_horizontal : bool = true
@export var track_vertical : bool = true

# follow allows player to move until outside of a certain area
# more typical for RPG game
@export var follow_horizontal : bool = false
@export var follow_vertical : bool = false

# how far from camera before it moves
# should be about 1/4 of window dimension, or less, can't be over 1/2
@export var follow_distance : Vector2 = Vector2(100, 100)

# speed to catch up to player
# can't be faster than player
@export var follow_speed : int = 100 

func _ready():
	
	if player == null:
		print("Setup error: Add player to CameraController node")
		return

func _process(delta):
	if player == null:
		return

	if follow_horizontal:
		# if the player is in the right or left quarter of screen, 
		# start moving to center player
		var d = position.x - player.position.x
		if abs(d) > follow_distance.x:
			position.x -= delta * follow_speed * sign(d)
	
	# follow horizontal ignores track setting
	elif track_horizontal:
		position.x = player.position.x
	
	# same thing for vertical
	if follow_vertical:
		var d = position.y - player.position.y
		if abs(d) > follow_distance.y:
			position.y -= delta * follow_speed * sign(d)
			
	elif track_vertical:
		position.y = player.position.y
