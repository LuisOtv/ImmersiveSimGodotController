extends RigidBody3D

# Holdable object properties
##This is the name that will appear on the HUD when looking at it
@export var objectName := "Holder"
@onready var collisionShape: CollisionShape3D = $Colision

# Reference to items manager
@onready var itemsManager = get_tree().get_first_node_in_group("ItemsManager")

# Handle interaction (pickup/hold)
func _interact():
	# Only allow pickup if player isn't holding anything
	if itemsManager.heldObject == null:
		itemsManager._holdObject(self)
