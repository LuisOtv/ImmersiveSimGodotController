extends RayCast3D

# Target marker reference
@onready var targetMarker: Marker3D = $"../Marker3D"

func _process(deltaTime: float) -> void:
	# Update raycast target to crosshair position
	target_position = targetMarker.global_transform.origin
