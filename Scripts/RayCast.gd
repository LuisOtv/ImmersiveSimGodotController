extends RayCast3D

# UI references
@export var interactionLabel = Label
@export var crosshairNode = Node3D

func _process(_deltaTime: float) -> void:
	# Get object the raycast is hitting
	var hitObject = get_collider()

	# Handle object interaction
	if hitObject != null and hitObject.is_in_group("Object"):
		# Update crosshair and label for interactable objects
		crosshairNode.outerSprite.global_position = hitObject.global_position
		interactionLabel.text = str(hitObject.objectName)
		crosshairNode._showOuter()

		# Handle interaction input
		if hitObject.is_in_group("Interactable") and Input.is_action_just_pressed("ui_f"):
			hitObject._interact()
	else:
		# Clear UI when not looking at anything
		interactionLabel.text = ""
		crosshairNode._reset()
