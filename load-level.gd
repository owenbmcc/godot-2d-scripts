"""
loads a level, reload current or go to next level
"""
extends Node

## scene/level to load
@export_file var load_level_path

func on_load(_node: Node) -> void:
	call_deferred("safe_load")

func safe_load() -> void:
	get_tree().change_scene_to_file(load_level_path)
