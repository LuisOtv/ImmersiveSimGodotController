extends StaticBody3D

@onready var label: Label = $SubViewport/Label
@export var password : String
@export var door : StaticBody3D
var current : String

func addNumber(num):
	current += num
	label.text = current

func erase():
	current = ""
	label.text = current
	
func checkPassword():
	if current == password:
		door._unlock()
	erase()
