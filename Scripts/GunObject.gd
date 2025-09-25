extends RigidBody3D

##This is the name that will appear on the HUD when looking at it
@export var objectName := "Holder"

@export_category("Ammo configuration") 
##Current ammo in the magazine
@export var currentAmmo : int
##Max magazine size
@export var magazineSize : int
##Ammo for reloading
@export var extraAmmo : int
##if "isShotgun" is active, this is the ammount of pellets the gun will fire
@export var pelletCount : int

@export_category("Weapon type flags") 

##Turns the gun into a automatic firing
@export var isAutomatic : bool
##Turns the gun into a shotgun
@export var isShotgun : bool

@export_category("Weapon statistics") 
##if "isShotgun" is active, this is the time between each fire
@export var timeBetweenShots := 1.0
##How much the gun model will move for each shot (lower number = more recoil)
@export var gunRecoilAmount := 1.0
##How much the camera will move for each shot (lower number = more recoil)
@export var cameraRecoilAmount := 1.0
##How long it takes for reloading
@export var reloadTime := 1.0
##if this is != 0, holding right click will change the camera fov, like a zoom
@export var scopeFieldOfView := 0.0

# Reference to weapons manager
@onready var weaponsManager = get_tree().get_first_node_in_group("ItemsManager")
@onready var inventory = get_tree().get_first_node_in_group("Inventory")

# Handle interaction (pickup)
func _interact():
	#_pickupGun()
	_pickupGunInventory()

# Pick up this weapon
func _pickupGun():
	# Create settings dictionary with all weapon properties
	var weaponSettings ={
		"Gun": objectName,
		"CurAmmo" : currentAmmo,
		"MagSize" : magazineSize,
		"ExtraAmmo" : extraAmmo,
		"Auto" : isAutomatic,
		"BPM" : timeBetweenShots,
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
		
# Pick up this weapon
func _pickupGunInventory():
	# Create settings dictionary with all weapon properties
	var weaponSettings ={
		"Gun": objectName,
		"CurAmmo" : currentAmmo,
		"MagSize" : magazineSize,
		"ExtraAmmo" : extraAmmo,
		"Auto" : isAutomatic,
		"BPM" : timeBetweenShots,
		"GunRecoil" : gunRecoilAmount,
		"CamRecoil" : cameraRecoilAmount,
		"ReloadTime" : reloadTime,
		"Shotgun" : isShotgun,
		"Pellets" : pelletCount,
		"ScopeFov" : scopeFieldOfView,
	}

	queue_free()
	inventory._pickUpItem(weaponSettings)
