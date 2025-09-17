extends StaticBody3D

# Button properties
var objectName: String
var elevator: StaticBody3D
var floorMarker: Marker3D
var floorNumber: int

# Handle button interaction
func _interact() -> void:
	# Only move elevator if not currently moving
	if !elevator.isMoving:
		elevator.goToFloor(floorMarker)
