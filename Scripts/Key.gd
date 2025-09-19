extends StaticBody3D

# Key properties
##This is the name that will appear on the HUD when looking at it
@export var objectName := "Holder"
##This key "Id", on the locked door, set the "requiredKey" variable the same name as this.
@export var keyName : String

# Handle key pickup
func _interact():
	# Add key to player inventory
	PlayerStats.keys.append(keyName)
	# Remove key from world
	queue_free()
