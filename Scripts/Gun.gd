extends Node3D

# --- Exported Variables ---
@export var objectName: String
@export var gunDropPrefab: PackedScene
@export var bulletPrefab: PackedScene
@export var fireSoundPlayer: AudioStreamPlayer3D
@export var reloadSoundPlayer: AudioStreamPlayer3D
@export var emptySoundPlayer: AudioStreamPlayer3D

# --- Weapon State Variables ---
var flashTimer: float
var isActive: bool
var currentBurstPerMinute: float
var currentReloadTime: float
var timeOut: float
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

@onready var weaponsManager = get_tree().get_first_node_in_group("ItemsManager")
@onready var HUDManager = get_tree().get_first_node_in_group("HUDManager")

# --- Helper para pegar o item atual ---
func _getWeaponItem():
	return HUDManager.inventory.bag.get_child(weaponsManager.bagSpace).item

# --- Main Process Loop ---
func _process(deltaTime: float) -> void:
	# Calculate shooting direction
	shootDirection = (crosshairNode.global_transform.origin - global_transform.origin).normalized()
	_updateMuzzleFlash(deltaTime)

	# Hide weapon if not active
	if not isActive:
		visible = false
		return

	visible = true

	# Handle reload animation
	if currentReloadTime >= 0:
		weaponsContainer.global_transform.origin = lerp(weaponsContainer.global_transform.origin, lowerPosition.global_transform.origin, 6 * deltaTime)
		currentReloadTime -= deltaTime
	# Handle object holding (lower weapon)
	elif weaponsContainer.isHoldingObject:
		weaponsContainer.global_transform.origin = lerp(weaponsContainer.global_transform.origin, lowerPosition.global_transform.origin, 6 * deltaTime)
		return
	# Normal weapon handling
	else:
		weaponsContainer.global_transform.origin = lerp(weaponsContainer.global_transform.origin, shoulderPosition.global_transform.origin, 6 * deltaTime)
		_updateUI()
		_handleShooting(deltaTime)
		_handleReload()
		_handleScoping()

# --- Visual Effects ---
func _updateMuzzleFlash(deltaTime: float) -> void:
	if flashTimer > 0:
		muzzleFlash.visible = true
		flashTimer -= deltaTime
	else:
		muzzleFlash.visible = false

# --- User Interface ---
func _updateUI() -> void:
	var weaponItem = _getWeaponItem()
	ammoLabel.text = str(weaponItem.CurAmmo)
	extraAmmoLabel.text = str(weaponItem.ExtraAmmo)

# --- Input Handlers ---

# Handle weapon scoping
func _handleScoping():
	var weaponItem = _getWeaponItem()
	if Input.is_action_pressed('ui_mouse_2') and weaponItem.ScopeFov > 0:
		cameraNode.fov = weaponItem.ScopeFov
		crosshairNode._showScope()
	else:
		cameraNode.fov = 75

# Handle weapon shooting based on weapon type
func _handleShooting(deltaTime: float) -> void:
	var weaponItem = _getWeaponItem()
	
	if weaponItem.Auto:
		# Automatic: continuous fire with rate limiting
		if Input.is_action_pressed("ui_mouse_1"):
			if currentBurstPerMinute <= 0:
				_shoot()
			else:
				currentBurstPerMinute -= deltaTime
		else:
			currentBurstPerMinute = 0
	else:
		# Semi-automatic: single shot per click
		if Input.is_action_just_pressed("ui_mouse_1"):
			_shoot()

# Handle weapon reloading
func _handleReload() -> void:
	var weaponItem = _getWeaponItem()
	
	if Input.is_action_just_pressed("ui_r") and weaponItem.ExtraAmmo > 0 and weaponItem.CurAmmo < weaponItem.MagSize:
		var neededAmmo = weaponItem.MagSize - weaponItem.CurAmmo
		var ammoToReload = min(neededAmmo, weaponItem.ExtraAmmo)

		weaponItem.CurAmmo += ammoToReload
		weaponItem.ExtraAmmo -= ammoToReload
		
		reloadSoundPlayer.play()
		currentReloadTime = weaponItem.ReloadTime

# --- Shooting Logic ---
func _shoot() -> void:
	var weaponItem = _getWeaponItem()
	
	if weaponItem.CurAmmo > 0 and timeOut >= 0:
		# Consume ammo
		weaponItem.CurAmmo -= 1
		currentBurstPerMinute = weaponItem.BPM
		flashTimer = 0.1

		# Create bullets based on weapon type
		if weaponItem.Shotgun:
			# Shotgun: multiple pellets with spread
			for i in range(weaponItem.Pellets):
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
			randf_range((springArmNode.get_hit_length() / weaponItem.GunRecoil) * -1, (springArmNode.get_hit_length() / weaponItem.GunRecoil)),
			randf_range(0, (springArmNode.get_hit_length() / weaponItem.GunRecoil)), 0
		)

		# Apply weapon recoil
		weaponsContainer.translate(Vector3(0, 0, 0.01 * weaponItem.GunRecoil))
		fireSoundPlayer.play()

		# Apply camera recoil
		cameraNode.rotate_x(0.01 * weaponItem.CamRecoil)
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
	ammoLabel.text = ""
	extraAmmoLabel.text = ""

func get_dic():
	var weaponItem = _getWeaponItem()
	return {
		"Gun": objectName,
		"CurAmmo": weaponItem.CurAmmo,
		"MagSize": weaponItem.MagSize,
		"ExtraAmmo": weaponItem.ExtraAmmo,
		"Auto": weaponItem.Auto,
		"BPM": weaponItem.BPM,
		"GunRecoil": weaponItem.GunRecoil,
		"CamRecoil": weaponItem.CamRecoil,
		"ReloadTime": weaponItem.ReloadTime,
		"Shotgun": weaponItem.Shotgun,
		"Pellets": weaponItem.Pellets,
		"ScopeFov": weaponItem.ScopeFov,
	}
