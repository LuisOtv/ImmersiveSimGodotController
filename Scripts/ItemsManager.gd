extends Node3D

# UI and positioning references
@onready var crosshairNode: Node3D = $"../../CrossHair"
@onready var equipSound: AudioStreamPlayer3D = $"../../../Sounds/Equip"
@onready var objectDropPoint: Marker3D = $"../Drop"
@onready var lowerPosition: Marker3D = $"../../LowerPos"

# Weapon references
@onready var p250: Node3D = $P250
@onready var m4: Node3D = $M4
@onready var m24: Node3D = $M24
@onready var browning: Node3D = $Browning

# State variables
var isHoldingGun: bool
var currentGun: Node3D
var currentSlot: Control

var isHoldingObject: bool
var heldObject: Node3D

# Current throw/drop direction
var throwDirection: Vector3

@onready var Inventory = get_tree().get_first_node_in_group("Inventory")

func _process(_deltaTime: float) -> void:
	# Calculate direction for throwing/dropping
	throwDirection = (crosshairNode.global_transform.origin - global_transform.origin).normalized()

	# Update held object position
	if isHoldingObject:
		heldObject.global_transform = objectDropPoint.global_transform

	# Look at crosshair but keep level rotation
	look_at(crosshairNode.global_transform.origin, Vector3.UP)
	rotation.z = 0

# Handle drop/throw input
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_g"):
		if isHoldingObject:
			_throwObject()
		elif isHoldingGun:
			_dropGun()

# Pick up a weapon with given settings
func _pickupGun(weaponSettings):
	# Get the weapon node based on name
	currentGun = get(weaponSettings["Gun"].to_lower())

	# Apply all weapon settings
	currentGun.isActive = true
	currentGun.currentAmmo = weaponSettings["CurAmmo"]
	currentGun.magazineSize = weaponSettings["MagSize"]
	currentGun.extraAmmo = weaponSettings["ExtraAmmo"]
	currentGun.isAutomatic = weaponSettings["Auto"]
	currentGun.timeBetweenShots = weaponSettings["BPM"]
	currentGun.gunRecoilAmount = weaponSettings["GunRecoil"]
	currentGun.cameraRecoilAmount = weaponSettings["CamRecoil"]
	currentGun.reloadTime = weaponSettings["ReloadTime"]
	currentGun.isShotgun = weaponSettings["Shotgun"]
	currentGun.pelletCount = weaponSettings["Pellets"]
	currentGun.scopeFieldOfView = weaponSettings["ScopeFov"]

	# Play pickup sound
	equipSound.play()
	
	isHoldingGun = true

# Drop currently held weapon
func _dropGun():
	# Create dropped weapon instance
	var droppedGun = currentGun.gunDropPrefab.instantiate()
	droppedGun.global_position = objectDropPoint.global_position
	droppedGun.rotate_y(randf_range(0, TAU))
	droppedGun.rotate_z(randf_range(0, TAU))

	# Transfer weapon properties to dropped instance
	droppedGun.objectName = currentGun.objectName
	droppedGun.magazineSize = currentGun.magazineSize
	droppedGun.extraAmmo = currentGun.extraAmmo
	droppedGun.isAutomatic = currentGun.isAutomatic
	droppedGun.timeBetweenShots = currentGun.timeBetweenShots
	droppedGun.currentAmmo = currentGun.currentAmmo
	droppedGun.reloadTime = currentGun.reloadTime
	droppedGun.gunRecoilAmount = currentGun.gunRecoilAmount
	droppedGun.cameraRecoilAmount = currentGun.cameraRecoilAmount
	droppedGun.scopeFieldOfView = currentGun.scopeFieldOfView
	droppedGun.linear_velocity = throwDirection

	# Add to scene and reset current weapon
	get_tree().current_scene.add_child(droppedGun)
	currentGun._reset()
	
	isHoldingGun = false
	currentGun = null
	
	Inventory.dropItem(currentSlot.selectedSpace)
	Inventory.updateInventory()
	
# Hold/carry an object
func _holdObject(objectToHold):
	isHoldingObject = true
	heldObject = objectToHold
	heldObject.collisionShape.disabled = true

# Throw currently held object
func _throwObject():
	isHoldingObject = false
	heldObject.linear_velocity = throwDirection
	heldObject.collisionShape.disabled = false
	heldObject = null
