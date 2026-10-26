"""
UI menus, used for splash screen, game over, etc.
connect signals from UI buttons
change scene to load a level or another scene
quit to quit

node setup (Example layout, should be modified for specific design)
• Control #Menu.gd (StartMenu, GameOverMenu, WinMenu, Instructions, etc)
	• CenterContainer
		• HBoxContainer
			• CenterContainer
				• TextureRect (Title, Graphic)
			• CenterContainer
				• VBoxContainer
				• TextureButton (StartButton)
				• TextureButton (QuitButton)
				• More buttons
	~ AudioStreamPlayer (HoverSound)
	~ AudioStreamPlayer (BackgroundMusic)

signals
StartButton pressed -> _on_StartButton_pressed
InstructionsButton pressed -> _on_InstructionsButton_pressed
QuitButton pressed -> _on_QuitButton_pressed
~ (Any)Button mouse_entered -> _on_mouse_entered
"""

extends Control

@export_file var load_level_path
@export_file var instructions_path

func _ready():
	
	#check for setup issues
	if load_level_path == null:
		print("Menu setup error: Add level to Load Level Path")
		return
	
	if instructions_path == null:
		print("Menu setup error: Add istructions to Instructions Path (or remove)")
		return
	

# connect pressed signal from start button
func _on_StartButton_pressed():
	get_tree().change_scene_to_file(load_level_path)

# connect pressed signal from instructions button
func _on_InstructionsButton_pressed():
	get_tree().change_scene_to_file(instructions_path)

# connect pressed signal from quit button
func _on_QuitButton_pressed():
	get_tree().quit()

# other buttons, add pressed signal and create new method

# uncomment and connect signals for ui sfx

# connect mouse_entered signal from any button for hover sound
# func _on_mouse_entered():
#	$HoverSound.play()
