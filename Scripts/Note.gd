extends StaticBody3D

##This is the name that will appear on the HUD when looking at it
@export var objectName := "Holder"

@export var title := "Holder"
@export var text := "Holder"
@export var texture : Texture2D

@onready var HUDManager = get_tree().get_first_node_in_group("HUDManager")

# Handle key pickup
func _interact():
	# Add key to player inventory
	HUDManager.notes.openNote(texture,title,text)
