extends StaticBody3D

# NPC properties
##This is the name that will appear on the HUD when looking at it
@export var objectName := "Holder"
@export var speechLines: Array[String]
@export var isTarget := false

# UI reference
@onready var textBoxUI = get_tree().get_first_node_in_group("TextBox")

# Handle NPC interaction
func _interact():
	# Show dialogue with random speech line
	textBoxUI.visible = true
	textBoxUI.currentText = speechLines.pick_random()
	textBoxUI.updateText()
