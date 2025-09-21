extends Control

@onready var bar: HBoxContainer = $Bar
const hotbarSlot = preload("uid://dq5wfh5ebspwp")

func _ready() -> void:
	for i in 9:
		var slot = hotbarSlot.instantiate()
		slot.space = i + 1
		bar.add_child(slot)
	
func _pickUpItem(item):
	for i in bar.get_children():
		if i.item.is_empty():
			i.item = item
			break
