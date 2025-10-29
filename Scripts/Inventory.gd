extends Control

@onready var bag: GridContainer = $Bag
@onready var bar: HBoxContainer = $Bar
const hotbarSlot = preload("uid://dq5wfh5ebspwp")
const bagSlot = preload("uid://pad84dlqwl61")

@export var hotbarSize := 9
@export var bagSize := 32

func _ready() -> void:
	# Inicializa inventário
	PlayerStats.items.resize(bagSize)
	for i in range(PlayerStats.items.size()):
		PlayerStats.items[i] = {}

	# Hotbar
	for i in range(hotbarSize):
		var slot = hotbarSlot.instantiate()
		slot.space = i + 1
		bar.add_child(slot)

	# Bag
	for i in range(PlayerStats.items.size()):
		var slot = bagSlot.instantiate()
		slot.space = i
		bag.add_child(slot)

func _pickUpItem(item: Dictionary) -> void:
	for i in range(PlayerStats.items.size()):
		if PlayerStats.items[i].is_empty():
			PlayerStats.items[i] = item
			break
	updateInventory()

func dropItem(id):
	PlayerStats.items[id] = {}
	updateInventory()

func updateInventory() -> void:
	# Hotbar 
	for child in bar.get_children():
		var idx = child.selectedSpace
		if idx >= 0 and idx < PlayerStats.items.size():
			if PlayerStats.items[idx].is_empty():
				child.clear()
			else:
				child.item = PlayerStats.items[idx]
		child.check()

	# Bag
	for idx in range(bag.get_child_count()):
		var child = bag.get_child(idx)
		if PlayerStats.items[idx].is_empty():
			child.clear()
		else:
			child.item = PlayerStats.items[idx]
		child.check()

	# Debug
	for i in range(PlayerStats.items.size()):
		print(i, " -> ", PlayerStats.items[i])
