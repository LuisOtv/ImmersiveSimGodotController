extends Node3D

# --- Exported Variables ---
@export var objectName: String
@export var gunDropPrefab: PackedScene
@export var bulletPrefab: PackedScene
@export var fireSoundPlayer: AudioStreamPlayer3D
@export var reloadSoundPlayer: AudioStreamPlayer3D
@export var emptySoundPlayer: AudioStreamPlayer3D

# --- Weapon State Variables ---
var flashTimer: int
var isActive: bool
var currentBurstPerMinute: float
# --- Ammo System ---
var currentAmmo: int
var magazineSize: int
var extraAmmo: int
var currentReloadTime: int
var reloadTime: int
var pelletCount: int

# --- Weapon Configuration ---
var isAutomatic: bool
var isShotgun: bool
var timeBetweenShots: float
var gunRecoilAmount: float
var cameraRecoilAmount: float
var scopeFieldOfView: float
var timeOut: int

# --- Shooting Direction ---
var shootDirection: Vector3

# --- Node References ---
@onready var cameraNode: Camera3D = $"../.."
@onready var ammoLabel: Label = $"../../../../HUD/CrosshairText/Ammo"
@onready var extraAmmoLabel: Label = $"../../../../HUD/CrosshairText/ExtraAmmo"
@onready var crosshairNode: Node3D = $"../../../CrossHair"
@onready var bulletSpawnPoint: Marker3D = $"../BulletSpawn"
@onready var muzzleFlash: MultiMeshInstance3D = $Flash
@onready var springArmNode: SpringArm3D = $"../../SpringArm3D"
@onready var weaponsContainer: Node3D = $".."
@onready var lowerPosition: Marker3D = $"../../../LowerPos"
@onready var shoulderPosition: Marker3D = $"../../ShoulderPos"

# --- Main Process Loop ---
func _process(_deltaTime: float) -> void:
	# Calculate shooting direction
	shootDirection = (crosshairNode.global_transform.origin - global_transform.origin).normalized()
	_updateMuzzleFlash()

	# Hide weapon if not active
	if not isActive:
		visible = false
		return

	visible = true

	# Handle reload animation
	if currentReloadTime >= 0:
		weaponsContainer.global_transform.origin = lerp(weaponsContainer.global_transform.origin, lowerPosition.global_transform.origin, 0.1)
		currentReloadTime -= 1
	# Handle object holding (lower weapon)
	elif weaponsContainer.isHoldingObject:
		weaponsContainer.global_transform.origin = lerp(weaponsContainer.global_transform.origin, lowerPosition.global_transform.origin, 0.1)
		return
	# Normal weapon handling
	else:
		weaponsContainer.global_transform.origin = lerp(weaponsContainer.global_transform.origin, shoulderPosition.global_transform.origin, 0.2)
		_updateUI()
		_handleShooting()
		_handleReload()
		_handleScoping()

# --- Visual Effects ---
func _updateMuzzleFlash() -> void:
	if flashTimer > 0:
		muzzleFlash.visible = true
		flashTimer -= 1
	else:
		muzzleFlash.visible = false

# --- User Interface ---
func _updateUI() -> void:
	ammoLabel.text = str(currentAmmo)
	extraAmmoLabel.text = str(extraAmmo)

# --- Input Handlers ---

# Handle weapon scoping
func _handleScoping():
	if Input.is_action_pressed('ui_mouse_2') and scopeFieldOfView > 0:
		cameraNode.fov = scopeFieldOfView
		crosshairNode._showScope()
	else:
		cameraNode.fov = 75

# Handle weapon shooting based on weapon type
func _handleShooting() -> void:

	if isAutomatic:
		# Automatic: continuous fire with rate limiting
		if Input.is_action_pressed("ui_mouse_1"):
			if currentBurstPerMinute <= 0:
				_shoot()
			else:
				currentBurstPerMinute -= 1
		else:
			currentBurstPerMinute = 0
	else:
		# Semi-automatic: single shot per click
		if Input.is_action_just_pressed("ui_mouse_1"):
			_shoot()

# Handle weapon reloading
func _handleReload() -> void:
	if Input.is_action_just_pressed("ui_r") and extraAmmo > 0 and currentAmmo < magazineSize:
		var neededAmmo = magazineSize - currentAmmo
		var ammoToReload = min(neededAmmo, extraAmmo)

		currentAmmo += ammoToReload
		extraAmmo -= ammoToReload
		reloadSoundPlayer.play()

		currentReloadTime = reloadTime

# --- Shooting Logic ---
func _shoot() -> void:
	if currentAmmo > 0 and timeOut >= 0:
		# Consume ammo
		currentAmmo -= 1
		currentBurstPerMinute = timeBetweenShots
		flashTimer = 1

		# Create bullets based on weapon type
		if isShotgun:
			# Shotgun: multiple pellets with spread
			for i in range(pelletCount):
				var spread = Vector3(
					randf_range(-0.05, 0.05),
					randf_range(-0.05, 0.05),
					randf_range(-0.05, 0.05)
				)
				_createBullet((shootDirection + spread).normalized())
		else:
			# Regular: single bullet
			_createBullet(shootDirection)

		# Apply crosshair spread for visual feedback
		crosshairNode.global_transform.origin += Vector3(
			randf_range((springArmNode.get_hit_length() / gunRecoilAmount) * -1, (springArmNode.get_hit_length() / gunRecoilAmount)),
			randf_range(0, (springArmNode.get_hit_length() / gunRecoilAmount)),0
		)

		# Apply weapon recoil
		weaponsContainer.translate(Vector3(0, 0, 0.01 * gunRecoilAmount))
		fireSoundPlayer.play()

		# Apply camera recoil
		cameraNode.rotate_x(0.01 * cameraRecoilAmount)
	else:
		# No ammo - play empty sound
		emptySoundPlayer.play()

# Create and spawn a bullet
func _createBullet(direction: Vector3) -> void:
	var newBullet = bulletPrefab.instantiate()
	newBullet.position = bulletSpawnPoint.global_transform.origin
	newBullet.linear_velocity = direction * 200
	get_tree().current_scene.add_child(newBullet)

# --- Weapon Reset ---
func _reset():
		isActive = false
		isAutomatic = false
		extraAmmo = 0
		timeBetweenShots = 0
		currentAmmo = 0
		magazineSize = 0
		ammoLabel.text = ""
		extraAmmoLabel.text = ""

func get_dic():
	return{
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
