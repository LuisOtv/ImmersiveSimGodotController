extends StaticBody3D

# NPC properties
##This is the name that will appear on the HUD when looking at it
@export var objectName := "Holder"
@export var speechLines: Array[String]
@export var isTarget := false

# UI reference
@onready var HUD = get_tree().get_first_node_in_group("HUDManager")

# Handle NPC interaction
func _interact():
	# Show dialogue with random speech line
	if speechLines.size() == 0 : return

	HUD.textbox.visible = true
	HUD.textbox.currentText = speechLines.pick_random()
	HUD.textbox.updateText()
