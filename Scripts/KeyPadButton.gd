extends StaticBody3D

##This is the name that will appear on the HUD when looking at it
@export var objectName := "Holder"

@export var number : String
@onready var label: Label = $SubViewport/Label
@onready var key_pad: StaticBody3D = $"../.."

func _ready() -> void:
	label.text = number

func _interact():
	key_pad.addNumber(number)
