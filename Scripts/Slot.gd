extends Node

var item := {}
var space : int
@onready var hasItem: Panel = $HasItem
@onready var isActive: Panel = $IsActive

# Reference to weapons manager
@onready var weaponsManager = get_tree().get_first_node_in_group("ItemsManager")

func _ready() -> void:
	print(space)

func _process(_delta: float) -> void:
	if item != {}:
		hasItem.visible = true
	else:
		hasItem.visible = false

	if Input.is_action_just_pressed("ui_slot_" + str(space)):
		if !item.is_empty():
			if weaponsManager.currentGun != null :
				weaponsManager.currentSlot.update(weaponsManager.currentGun.get_dic())
				weaponsManager.currentGun._reset()
			if weaponsManager.currentSlot != null :
				weaponsManager.currentSlot.deselect()
			
			weaponsManager._pickupGun(item)
			weaponsManager.currentSlot = self
			isActive.visible = true

func update(new):
	item = new

func reset():
	isActive.visible = false
	item = {}

func deselect():
	isActive.visible = false
	
