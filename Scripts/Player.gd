extends CharacterBody3D

# Player components
@onready var neckNode: Node3D = $Neck
@onready var cameraNode: Camera3D = $Neck/Camera3D
@onready var crosshairNode: Node3D = $Neck/CrossHair

# Position markers for different stances
@onready var centerPosition: Marker3D = $Neck/CenterPosition
@onready var leanLeftPosition: Marker3D = $Neck/LeanLeft
@onready var leanRightPosition: Marker3D = $Neck/LeanRight
@onready var dropPoint: Marker3D = $Neck/Camera3D/Drop

# Collision shapes for different stances
@onready var standingCollision: CollisionShape3D = $StandingCol
@onready var crouchingCollision: CollisionShape3D = $CrouchingCol

# Detection raycasts
@onready var topDetection: RayCast3D = $TopDetect
@onready var rightDetection: RayCast3D = $RightDetect
@onready var leftDetection: RayCast3D = $LeftDetect

# Stance position markers
@onready var crouchPosition: Marker3D = $Crouch
@onready var standingPosition: Marker3D = $Standing

# Movement speeds
var currentSpeed = 4.0
@export var walkingSpeed = 4.0
@export var runningSpeed = 6.0
@export var crouchingSpeed = 2.0
@export var ladderSpeed = 1.2
@export var jumpVelocity = 5.0

# Mouse sensitivity and camera limits
@export var mouseSensitivity = 0.002
var cameraMinAngle = -80.0 * PI / 180.0
var cameraMaxAngle = 80.0 * PI / 180.0
var cameraRotation = Vector3.ZERO

# Handle mouse look and escape menu
func _unhandled_input(event: InputEvent) -> void:
	# Mouse look when captured
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Horizontal rotation (body)
		rotate_y(-event.relative.x * mouseSensitivity)

		# Vertical rotation (camera) with clamping
		cameraRotation.x -= event.relative.y * mouseSensitivity
		cameraRotation.x = clamp(cameraRotation.x, cameraMinAngle, cameraMaxAngle)
		neckNode.rotation = cameraRotation

	# Toggle mouse capture with escape
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Handle stance changes and leaning
func _process(_deltaTime: float) -> void:
	# Normal movement state
	if PlayerStats.currentState == 'Normal':
		# Crouching logic
		if Input.is_action_pressed("ui_control") or topDetection.is_colliding() == true:
			neckNode.global_position = lerp(neckNode.global_position, crouchPosition.global_position, 0.1)
			standingCollision.disabled = true
			currentSpeed = crouchingSpeed
		else:
			neckNode.global_position = lerp(neckNode.global_position, standingPosition.global_position, 0.1)
			standingCollision.disabled = false
			currentSpeed = walkingSpeed
	
			# Running logic
			if Input.is_action_pressed("ui_shift"):
				currentSpeed = runningSpeed
			else:
				currentSpeed = walkingSpeed
		
		# Leaning logic
		if Input.is_action_pressed("ui_q") and !leftDetection.is_colliding():
			cameraNode.transform = lerp(cameraNode.transform, leanLeftPosition.transform, 0.1)
		elif Input.is_action_pressed("ui_e") and !rightDetection.is_colliding():
			cameraNode.transform = lerp(cameraNode.transform, leanRightPosition.transform, 0.1)
		else:
			cameraNode.fov = 75
			cameraNode.transform = lerp(cameraNode.transform, centerPosition.transform, 0.1)
	
	# Ladder climbing state
	elif PlayerStats.currentState == 'Ladder':
		standingCollision.disabled = true
		neckNode.global_position = lerp(neckNode.global_position, crouchPosition.global_position, 0.1)
		cameraNode.fov = 75

# Handle movement physics
func _physics_process(deltaTime: float) -> void:
	# Normal movement
	if PlayerStats.currentState == 'Normal':
		# Apply gravity when not on ground
		if not is_on_floor():
			velocity += get_gravity() * deltaTime

		# Jumping
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jumpVelocity

		# Horizontal movement
		var inputDirection := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var movementDirection := (transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
		
		if movementDirection:
			velocity.x = movementDirection.x * currentSpeed
			velocity.z = movementDirection.z * currentSpeed
		else:
			velocity.x = move_toward(velocity.x, 0, currentSpeed)
			velocity.z = move_toward(velocity.z, 0, currentSpeed)

	# Ladder climbing movement
	elif PlayerStats.currentState == 'Ladder':
		if Input.is_action_pressed("ui_up"):
			velocity.y = ladderSpeed
		elif Input.is_action_pressed("ui_down"):
			velocity.y = -ladderSpeed
		else:
			velocity.y = move_toward(velocity.y, 0, currentSpeed) 

	move_and_slide()
