extends RigidBody3D

# Gun pickup object properties
@export var objectName: String = "holder"

# Ammo configuration
@export var currentAmmo : int
@export var magazineSize : int
@export var extraAmmo : int
@export var pelletCount : int

# Weapon type flags
@export var isAutomatic : bool
@export var isShotgun : bool

# Weapon statistics
@export var burstPerMinute : float
@export var gunRecoilAmount : float
@export var cameraRecoilAmount: int
@export var reloadTime : int
@export var scopeFieldOfView : int

# Reference to weapons manager
@onready var weaponsManager = get_tree().get_first_node_in_group("ItemsManager")

# Handle interaction (pickup)
func _interact():
	_pickupGun()

# Pick up this weapon
func _pickupGun():
	# Create settings dictionary with all weapon properties
	var weaponSettings ={
		"Gun": objectName,
		"CurAmmo" : currentAmmo,
		"MagSize" : magazineSize,
		"ExtraAmmo" : extraAmmo,
		"Auto" : isAutomatic,
		"BPM" : burstPerMinute,
		"GunRecoil" : gunRecoilAmount,
		"CamRecoil" : cameraRecoilAmount,
		"ReloadTime" : reloadTime,
		"Shotgun" : isShotgun,
		"Pellets" : pelletCount,
		"ScopeFov" : scopeFieldOfView,
	}

	# Only pickup if player isn't already holding a gun
	if !weaponsManager.isHoldingGun:
		queue_free()
		weaponsManager._pickupGun(weaponSettings)
