# MMP 270 Default Scripts

This is a collection of scripts for a Godot 2D platform/RPG game for use in MMP 270.

To use the scripts, download this repository as a .zip archive from the green Code dropdown, extract the folder and place it in the root directory of the Godot project (it should be in the same folder as project.godot).

Each script has a comment at the top that describes how to use the script, the expected node structure, signals and other setup requirements.

```
• = node
~ = optional node
% = scene instance
() = example name
$ = use default node name (or code will error)
# = script to attach to the node
[] = collision layer name(s)
{} = mask layer name(s)
|| = group
-> = signal to function (other node or self)

• NodeType (node_name) # script.gd
	• ChildNodeType
	• CollisionShape3D [collision layer name]


followed by additional instructions
check @export comments for properties, some (optional)

```
