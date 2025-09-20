extends Node

var isHovering := false
var item : Dictionary
@onready var panel: Panel = $Panel

# Reference to weapons manager
@onready var weaponsManager = get_tree().get_first_node_in_group("ItemsManager")

func _process(_delta: float) -> void:
	if !item.is_empty():
		panel.visible = true

	if isHovering and item != null:
		if Input.is_action_pressed("ui_mouse_1"):
			for i in weaponsManager.get_children():
				if i is Node3D and i.has_method("_reset"):
					i._reset()
			weaponsManager._pickupGun(item)

func _on_mouse_entered() -> void:
	isHovering = true

func _on_mouse_exited() -> void:
	isHovering = false
