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
var bagSpace = -1

@onready var HUDManager = get_tree().get_first_node_in_group("HUDManager")

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
func _pickupGun(weaponSettings, _bagSpace):
	bagSpace = _bagSpace
	
	# Get the weapon node based on name
	currentGun = get(weaponSettings["Gun"].to_lower())
	
	# Apply all weapon settings direto ao item no inventário
	var weaponItem = HUDManager.inventory.bag.get_child(bagSpace).item
	weaponItem.CurAmmo = weaponSettings["CurAmmo"]
	weaponItem.MagSize = weaponSettings["MagSize"]
	weaponItem.ExtraAmmo = weaponSettings["ExtraAmmo"]
	weaponItem.Auto = weaponSettings["Auto"]
	weaponItem.BPM = weaponSettings["BPM"]
	weaponItem.GunRecoil = weaponSettings["GunRecoil"]
	weaponItem.CamRecoil = weaponSettings["CamRecoil"]
	weaponItem.ReloadTime = weaponSettings["ReloadTime"]
	weaponItem.Shotgun = weaponSettings["Shotgun"]
	weaponItem.Pellets = weaponSettings["Pellets"]
	weaponItem.ScopeFov = weaponSettings["ScopeFov"]
	
	# Ativar a arma
	currentGun.isActive = true
	
	# Play pickup sound
	equipSound.play()
	
	isHoldingGun = true

# Drop currently held weapon
func _dropGun():
	# Pegar o item atual do inventário
	var weaponItem = HUDManager.inventory.bag.get_child(bagSpace).item
	
	# Create dropped weapon instance
	var droppedGun = currentGun.gunDropPrefab.instantiate()
	droppedGun.global_position = objectDropPoint.global_position
	droppedGun.rotate_y(randf_range(0, TAU))
	droppedGun.rotate_z(randf_range(0, TAU))
	
	# Transfer weapon properties to dropped instance
	droppedGun.objectName = weaponItem.Gun
	droppedGun.magazineSize = weaponItem.MagSize
	droppedGun.extraAmmo = weaponItem.ExtraAmmo
	droppedGun.isAutomatic = weaponItem.Auto
	droppedGun.timeBetweenShots = weaponItem.BPM
	droppedGun.currentAmmo = weaponItem.CurAmmo
	droppedGun.reloadTime = weaponItem.ReloadTime
	droppedGun.gunRecoilAmount = weaponItem.GunRecoil
	droppedGun.cameraRecoilAmount = weaponItem.CamRecoil
	droppedGun.scopeFieldOfView = weaponItem.ScopeFov
	droppedGun.linear_velocity = throwDirection * 10
	
	# Add to scene and reset current weapon
	get_tree().current_scene.add_child(droppedGun)
	currentGun._reset()
	
	isHoldingGun = false
	currentGun = null
	
	HUDManager.inventory.dropItem(currentSlot.selectedSpace)
	HUDManager.inventory.updateInventory()

# Hold/carry an object
func _holdObject(objectToHold):
	isHoldingObject = true
	heldObject = objectToHold
	heldObject.collisionShape.disabled = true

# Throw currently held object
func _throwObject():
	isHoldingObject = false
	heldObject.linear_velocity = throwDirection * 10
	heldObject.collisionShape.disabled = false
	heldObject = null
