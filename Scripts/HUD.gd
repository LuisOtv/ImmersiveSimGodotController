extends Control

# Camera and UI references
@onready var cameraNode: Camera3D = $"../Neck/Camera3D"
@onready var distanceLabel: Label = $CrosshairText/Meters
@onready var springArmNode: SpringArm3D = $"../Neck/Camera3D/SpringArm3D"
@onready var crosshairTextContainer: Control = $CrosshairText
@onready var crosshairNode: Node3D = $"../Neck/CrossHair"
@onready var gunTargetMarker: Marker3D = $"../Neck/Camera3D/SpringArm3D/GunTarget"

@onready var crosshair_text: Control = $CrosshairText
@onready var textbox: Control = $TextBox
@onready var inventory: Control = $Inventory
@onready var notes: Control = $Notes

@export var crosshairFollow := 3

func _process(deltaTime: float) -> void:
	# Update distance display
	distanceLabel.text = str(int(springArmNode.get_hit_length()))
	
	# Update crosshair position on screen
	var crosshairScreenPosition = cameraNode.unproject_position(crosshairNode.position)
	crosshairNode.global_position = lerp(crosshairNode.global_position, gunTargetMarker.global_position, crosshairFollow * deltaTime)
	crosshairTextContainer.position = crosshairScreenPosition

func _unhandled_key_input(_event: InputEvent) -> void:
	if notes.visible:
		if Input.is_action_just_pressed("ui_cancel"):
			notes.visible = false

	if Input.is_action_just_pressed("ui_tab") and !notes.visible:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			inventory.bag.visible = true
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			inventory.bag.visible = false

	if Input.is_action_just_pressed("ui_cancel") and inventory.bag.visible :
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		inventory.bag.visible = false
