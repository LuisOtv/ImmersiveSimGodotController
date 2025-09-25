extends StaticBody3D

# Elevator configuration
@onready var buttonMarker: Marker3D = $ButtonPos
@export var numberOfButtons: int
@export var floorDistance: float
@export var startingFloor: int
@export var butt: PackedScene

# References
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var goToMarker : Marker3D
@onready var floorsNode: Node3D = $Floors

# State variables
var buttonCount = 0
var isMoving = false
var currentFloor = 0
var floors: Array[Marker3D] = []

func _ready() -> void:
	# Make floors node independent of elevator movement
	floorsNode.top_level = true
	
	# Create ground floor (floor 0)
	var firstButton = butt.instantiate()
	var firstFloor = Marker3D.new()
	floorsNode.add_child(firstFloor)
	firstFloor.global_position = global_position
	print("Elevator position: ", global_position)
	print("First floor position: ", firstFloor.global_position)
	floors.append(firstFloor)
	firstButton.elevator = self
	firstButton.objectName = str(buttonCount) + " Floor"
	firstButton.transform.origin = buttonMarker.position + Vector3(0, -0.15 * buttonCount, 0)
	firstButton.floorMarker = firstFloor
	add_child(firstButton)
	buttonCount += 1
	
	# Create additional floors
	for i in range(numberOfButtons):
		var floorHeight = Marker3D.new()
		floorsNode.add_child(floorHeight) 
		floorHeight.global_position = Vector3(global_position.x, global_position.y + (floorDistance * buttonCount), global_position.z)
		floors.append(floorHeight)
		var buttonInstance = butt.instantiate()
		buttonInstance.elevator = self
		buttonInstance.objectName = str(buttonCount) + " Floor"
		buttonInstance.transform.origin = buttonMarker.position + Vector3(0, -0.15 * buttonCount, 0)
		buttonInstance.floorMarker = floorHeight
		add_child(buttonInstance)
		buttonCount += 1
	
	# Set starting position
	if startingFloor >= 0 and startingFloor < floors.size():
		global_position = floors[startingFloor].global_position
		currentFloor = startingFloor

# Move elevator to specified floor
func goToFloor(targetFloor: Marker3D):
	# Prevent movement if already moving
	if isMoving:
		return
	
	isMoving = true
	var elevatorSpeed = 2.0
	
	# Movement loop
	while isMoving:
		var deltaTime = get_process_delta_time()
		var targetPosition = targetFloor.global_position
		var currentPosition = global_position
		
		var distanceToTarget = currentPosition.distance_to(targetPosition)
		
		# Stop when close enough to target
		if distanceToTarget < 0.05:
			isMoving = false
			global_position = targetPosition
			player.global_position.y = global_position.y + 1
			break
		
		# Move elevator and player
		global_position = global_position.move_toward(targetPosition, elevatorSpeed * deltaTime)
		player.global_position.y = global_position.y + 1
		
		await get_tree().process_frame
