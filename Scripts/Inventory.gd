extends Control

@onready var bar: HBoxContainer = $Bar
const hotbarSlot = preload("uid://dq5wfh5ebspwp")

func _ready() -> void:
	for i in 9:
		var slot = hotbarSlot.instantiate()
		bar.add_child(slot)
