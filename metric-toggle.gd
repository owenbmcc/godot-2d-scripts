"""
metric that is either on or off based on a value number, like number of lives
multiple sprites to display current value
add to metrics manager, as instance or in scene
Sprite2D/AnimatedSprite2D for each count, for example 3 lives

node setup
• Control (MetricsManager)
	• Control #MetricToggle (MetricName)
		• AnimatedSprite2D (or TextureRect/Sprite2D)
		• AnimatedSprite2D (or TextureRect/Sprite2D)
		• AnimatedSprite2D (or TextureRect/Sprite2D)
"""

extends Node

@export var metric_name : String = "item_name"
@export var display_sprites_paths : Array[NodePath]
var display_sprites = Array()

func _ready():
	for path in display_sprites_paths:
		display_sprites.append(get_node(path))

# update called by metrics manager
func update_display(value):
	for i in display_sprites.size():
		# display only icons that match the value
		display_sprites[i].visible = ((i + 1) <= value)
