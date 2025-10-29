extends Node

var selectedSpace := -1
var item := {}
var space : int

@onready var hasItem: Panel = $HasItem
@onready var isActive: Panel = $IsActive

# Reference to weapons manager
@onready var weaponsManager = get_tree().get_first_node_in_group("ItemsManager")
@onready var HUDManager = get_tree().get_first_node_in_group("HUDManager")

func _unhandled_key_input(_event: InputEvent) -> void:
		if !item.is_empty():
			if Input.is_action_just_pressed("ui_slot_" + str(space)):
				weaponsManager.currentSlot = self
				if weaponsManager.currentGun != null:
					weaponsManager.currentGun._reset()

				weaponsManager._pickupGun(PlayerStats.items[selectedSpace], selectedSpace)

func check():
	if !item.is_empty():
		hasItem.visible = true
	else:
		hasItem.visible = false

func clear():
	item = {}
	selectedSpace = -1
