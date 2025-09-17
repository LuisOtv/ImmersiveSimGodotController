extends RigidBody3D

# Holdable object properties
@export var objectName: String = "ObjectName"
@onready var collisionShape: CollisionShape3D = $Colision

# Reference to items manager
@onready var itemsManager = get_tree().get_first_node_in_group("ItemsManager")

# Handle interaction (pickup/hold)
func _interact():
	# Only allow pickup if player isn't holding anything
	if itemsManager.heldObject == null:
		itemsManager._holdObject(self)
