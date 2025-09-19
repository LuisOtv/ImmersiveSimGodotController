extends StaticBody3D

# Door properties
##This is the name that will appear on the HUD when looking at it
@export var objectName := "Holder"
@export var isLocked: bool
@export var requiredKey: String

# Audio components
@onready var openDoorSound: AudioStreamPlayer3D = $"../OpenDoor"
@onready var unlockDoorSound: AudioStreamPlayer3D = $"../UnlockDoor"

# Door state
var isOpen = false

# Animation controller
@export var animationPlayer: AnimationPlayer

# Handle door interaction
func _interact():
	# Check if door is locked
	if isLocked:
		# Try to unlock with matching key
		for keyName in PlayerStats.keys:
			if keyName == requiredKey:
				_unlock()
	else:
		# Open/close door if not currently animating
		_open()
				
# Unlock the door
func _unlock():
	isLocked = false
	unlockDoorSound.play()
	_open()
	
func _open():
	if !animationPlayer.is_playing():
			openDoorSound.play()

			if isOpen:
				animationPlayer.play("close")
				isOpen = false
			else:
				animationPlayer.play("open")
				isOpen = true
