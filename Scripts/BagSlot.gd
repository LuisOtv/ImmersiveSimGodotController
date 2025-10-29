extends Node

var space: int
var item := {}
var selected = false

@onready var hasItem: Panel = $HasItem
@onready var isActive: Panel = $IsActive
@onready var weaponsManager = get_tree().get_first_node_in_group("ItemsManager")
@onready var HUDManager = get_tree().get_first_node_in_group("HUDManager")

const MAX_SLOTS = 9

func _unhandled_key_input(_event: InputEvent) -> void:
	if item.is_empty() or !selected:
		return
	
	var pressed_slot = _get_pressed_slot()
	if pressed_slot == -1:
		return
	
	_clear_previous_selections()
	_assign_to_slot(pressed_slot)
	HUDManager.inventory.updateInventory()

func _get_pressed_slot() -> int:
	for slot_number in range(1, MAX_SLOTS + 1):
		if Input.is_action_just_pressed("ui_slot_" + str(slot_number)):
			return slot_number
	return -1

func _clear_previous_selections() -> void:
	for slot_ui in HUDManager.inventory.bar.get_children():
		if slot_ui.selectedSpace == space:
			slot_ui.clear()
			print("cleared")

func _assign_to_slot(slot_number: int) -> void:
	var slot_index = slot_number - 1
	if slot_index < HUDManager.inventory.bar.get_child_count():
		HUDManager.inventory.bar.get_child(slot_index).selectedSpace = space

func clear() -> void:
	item = {}
	check()

func check() -> void:
	hasItem.visible = !item.is_empty()

func _on_mouse_entered() -> void:
	selected = true

func _on_mouse_exited() -> void:
	selected = false
