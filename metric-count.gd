"""
metric that counts up from 0
can be its own scene/component or inside Metrics scene

node setup
• Control (MetricsManager)
	• Control #MetricCount.gd (ItemName)
		• AnimatedSprite2D (or TextureRect/Sprite) icon image for metric
		• Label (to display count)
"""

extends Control

# reference to Global value if tracking globally
@export var metric_name : String = "item"

func _ready():
	if $Label == null:
		print("MetricCount setup error: Add Label node")

# update value display
func update_display(value):
	$Label.text = str(value) # String(Global[item_name])
