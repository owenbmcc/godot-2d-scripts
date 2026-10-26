"""
updates visual display based on global items
item strings have to match Global items/collectibles
add on top of regular level

node setup (add control node for each metric, examples below)
• Control #MetricsManager.gd (MetricsManager)
	• Control #MetricCount.gd (Items, Coins, Points)
		• Label
		~ AnimatedSprite2D (Icon)
	• Control #MetricToggle.gd (Life, anything with set number) 
		• AnimatedSprite2D (Life1)
		• AnimatedSprite2D (Life2)
		• AnimatedSprite2D (Life3)

in level
• Node2D (Level 1)
	• CanvasLayer (UI)
		• MetricsManager (instance)
"""

extends Node

# get an array (list) of references to display nodes for each metric
@export var metrics_paths : Array[NodePath]
var metrics = Array()

var global_ref : Node

func _ready():
	global_ref = get_node_or_null("/root/Global")
	if global_ref == null:
		print("Metrics manager setup error: add Global to Autoload")
		return

	for path in metrics_paths:
		metrics.append(get_node(path))
	# load the metrics from path
	update()

func update():
	for metric in metrics:
		var value = 0
		if global_ref.props.has(metric.metric_name):
			value = global_ref.props[metric.metric_name]
		metric.update_display(value)
