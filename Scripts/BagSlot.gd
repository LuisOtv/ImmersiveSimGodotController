extends Node

var space : int
var item := {}

var selected = false

@onready var hasItem: Panel = $HasItem
@onready var isActive: Panel = $IsActive

# Reference to weapons manager
@onready var weaponsManager = get_tree().get_first_node_in_group("ItemsManager")
@onready var HUDManager = get_tree().get_first_node_in_group("HUDManager")

func _unhandled_key_input(_event: InputEvent) -> void:
	if !item.is_empty() and selected:
		var pressed_slot = -1
		
		for slot_number in range(1, 10):
			if Input.is_action_just_pressed("ui_slot_" + str(slot_number)):
				pressed_slot = slot_number
				break
	
		match pressed_slot:
			1:
				HUDManager.inventory.bar.get_child(0).selectedSpace = space
			2:
				HUDManager.inventory.bar.get_child(1).selectedSpace = space
			3:
				HUDManager.inventory.bar.get_child(2).selectedSpace = space
			4:
				HUDManager.inventory.bar.get_child(3).selectedSpace = space
			5:
				HUDManager.inventory.bar.get_child(4).selectedSpace = space
			6:
				HUDManager.inventory.bar.get_child(5).selectedSpace = space
			7:
				HUDManager.inventory.bar.get_child(6).selectedSpace = space
			8:
				HUDManager.inventory.bar.get_child(7).selectedSpace = space
			9:
				HUDManager.inventory.bar.get_child(8).selectedSpace = space
			_:
				return
		
		HUDManager.inventory.updateInventory()

func clear():
	item = {}
	
func check():
	if !item.is_empty():
		hasItem.visible = true
	else:
		hasItem.visible = false

func _on_mouse_entered() -> void:
	selected = true

func _on_mouse_exited() -> void:
	selected = false
