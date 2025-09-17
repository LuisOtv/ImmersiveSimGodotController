extends StaticBody3D

# Ladder properties
@export var objectName: String = "Ladder"

# Movement constants
const STOP_THRESHOLD := 0.05
const MOVE_SPEED := 0.1

# References and markers
@onready var playerNode = get_tree().get_first_node_in_group("Player")
@onready var bottomMarker: Marker3D = $Bottom
@onready var topMarker: Marker3D = $Top
@onready var moveTimer: Timer = $Move
@onready var bottomDropPoint: Marker3D = $BottomDrop
@onready var topDropPoint: Marker3D = $TopDrop

# State variables
var isClimbing := false
var isActive := false

var targetMarker: Marker3D

func _process(_deltaTime: float) -> void:
	# Exit if no player reference or ladder not active
	if playerNode == null or !isActive:
		return

	# Handle climbing movement
	if isClimbing:
		playerNode.global_transform.origin = playerNode.global_transform.origin.move_toward(targetMarker.global_transform.origin, MOVE_SPEED)
		playerNode.crouchingCollision.disabled = true

		# Stop climbing when reached target
		if playerNode.global_transform.origin.distance_to(targetMarker.global_transform.origin) < STOP_THRESHOLD:
			isClimbing = false

	# Check if player moved outside ladder bounds
	if not isClimbing:
		_checkExitBounds()

# Handle ladder interaction
func _interact():
	if playerNode != null and PlayerStats.currentState == "Normal":
		PlayerStats.currentState = "Ladder"
		isActive = true
		_getOnLadder()

# Start climbing - determine which end is closer
func _getOnLadder():
	var bottomDistance = playerNode.global_transform.origin.distance_to(bottomMarker.global_transform.origin)
	var topDistance = playerNode.global_transform.origin.distance_to(topMarker.global_transform.origin)
	
	# Move to whichever end is closer
	targetMarker = bottomMarker if bottomDistance < topDistance else topMarker
	isClimbing = true
	
	# Stop player movement
	playerNode.velocity.x = 0
	playerNode.velocity.y = 0
	playerNode.velocity.z = 0
	
# Check if player moved outside ladder bounds and exit if needed
func _checkExitBounds():
	if playerNode.global_transform.origin.y < bottomMarker.global_transform.origin.y - 0.2:
		_exitLadder(bottomDropPoint)
	elif playerNode.global_transform.origin.y > topMarker.global_transform.origin.y + 0.2:
		_exitLadder(topDropPoint)

# Exit ladder and restore normal player state
func _exitLadder(dropPosition: Marker3D):
	playerNode.global_transform.origin = dropPosition.global_transform.origin
	playerNode.crouchingCollision.disabled = false
	PlayerStats.currentState = "Normal"
	playerNode.velocity.y = 0
	isActive = false
	isClimbing = false
