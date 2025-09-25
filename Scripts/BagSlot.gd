extends Node

var space : int
var item := {}

var selected = false

@onready var hasItem: Panel = $HasItem
@onready var isActive: Panel = $IsActive

# Reference to weapons manager
@onready var weaponsManager = get_tree().get_first_node_in_group("ItemsManager")
@onready var Inventory = get_tree().get_first_node_in_group("Inventory")

func _unhandled_key_input(_event: InputEvent) -> void:
	if !item.is_empty() and selected:
		var pressed_slot = -1
		
		# Determina qual slot foi pressionado
		for slot_number in range(1, 10):
			if Input.is_action_just_pressed("ui_slot_" + str(slot_number)):
				pressed_slot = slot_number
				break
		
		# Usa match para lidar com cada caso
		match pressed_slot:
			1:
				Inventory.bar.get_child(0).selectedSpace = space
			2:
				Inventory.bar.get_child(1).selectedSpace = space
			3:
				Inventory.bar.get_child(2).selectedSpace = space
			4:
				Inventory.bar.get_child(3).selectedSpace = space
			5:
				Inventory.bar.get_child(4).selectedSpace = space
			6:
				Inventory.bar.get_child(5).selectedSpace = space
			7:
				Inventory.bar.get_child(6).selectedSpace = space
			8:
				Inventory.bar.get_child(7).selectedSpace = space
			9:
				Inventory.bar.get_child(8).selectedSpace = space
			_:
				return  # Nenhuma tecla de slot foi pressionada
		
		Inventory.updateInventory()

func clear():
	item = {}
	
func check():
	if !item.is_empty():
		hasItem.visible = true
	else:
		hasItem.visible = false



func _on_mouse_entered() -> void:
	selected = true
	print("se")

func _on_mouse_exited() -> void:
	selected = false
