extends StaticBody3D

# Key properties
@export var keyName : String
@export var objectName : String

# Handle key pickup
func _interact():
	# Add key to player inventory
	PlayerStats.keys.append(keyName)
	# Remove key from world
	queue_free()
