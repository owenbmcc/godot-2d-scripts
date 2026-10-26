"""
requires Dialogue Manager plugin
https://github.com/nathanhoad/godot_dialogue_manager
import from AssetLib

add dialog for NPC character
on player enter, either starts dialog, or shows label to confirm

for label confirmation, add "StartDialog" to Input Map
Project > Project Settings > Input Map

node setup
• Area2D #NPCDialog.gd (NPC Name) (Layer: NPC, Mask: Player)
	• AnimatedSprite2D
	• CollisionShape2D
	~ Label

signals
Area2D body_entered -> _on_body_entered
Area2D body_exited -> _on_body_exited
"""

extends Area2D

# load dialog resource file created with Dialogue Manager
@export var dialog_resource : DialogueResource

# match dialogue name to dialog_start
@export var dialog_start : String = "start"

# set false to open confirmation label
@export var trigger_on_enter : bool = true

# custom dialog balloon
@export var dialog_balloon : PackedScene

var is_player_entered : bool = false

func _ready() -> void:
	$Label.visible = false

func _unhandled_input(_event : InputEvent) -> void:
	if not is_player_entered:
		return
	if trigger_on_enter:
		return
	if Input.is_action_just_pressed("StartDialog"):
		if dialog_balloon:
			var balloon: Node = dialog_balloon.instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(dialog_resource, dialog_start)
		else:
			DialogueManager.show_example_dialogue_balloon(dialog_resource, dialog_start)
		return
	
func show_dialog() -> void:
	$Label.visible = false
	DialogueManager.show_example_dialogue_balloon(dialog_resource, dialog_start)
	
func show_label() -> void:
	$Label.visible = true

# connect _on_body_entered signal from Area2D/NPC root node
# adds player entered, shows label if using label
func _on_body_entered(body) -> void:
	is_player_entered = true
	await get_tree().physics_frame
	body.input_vector = Vector2.ZERO
	if trigger_on_enter:
		show_dialog()
	else:
		show_label()

# connect _on_body_exited signal from Area2D/NPC root node
# removes player entered and hides label
func _on_body_exited(_body) -> void:
	is_player_entered = false
	$Label.visible = false
