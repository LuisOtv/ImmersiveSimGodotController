extends Control

# Camera and UI references
@onready var cameraNode: Camera3D = $"../Neck/Camera3D"
@onready var distanceLabel: Label = $CrosshairText/Meters
@onready var springArmNode: SpringArm3D = $"../Neck/Camera3D/SpringArm3D"
@onready var crosshairTextContainer: Control = $CrosshairText
@onready var crosshairNode: Node3D = $"../Neck/CrossHair"
@onready var gunTargetMarker: Marker3D = $"../Neck/Camera3D/SpringArm3D/GunTarget"

func _process(_deltaTime: float) -> void:
	# Update distance display
	distanceLabel.text = str(int(springArmNode.get_hit_length()))
	
	# Update crosshair position on screen
	var crosshairScreenPosition = cameraNode.unproject_position(crosshairNode.position)
	crosshairNode.global_position = lerp(crosshairNode.global_position, gunTargetMarker.global_position, 0.3)
	crosshairTextContainer.position = crosshairScreenPosition
