extends Node3D

# Different crosshair sprites for different states
@onready var outerSprite: Sprite3D = $OuterCrossHair
@onready var normalSprite: Sprite3D = $NormalCrossHair
@onready var scopeSprite: Sprite3D = $ScopeCrossHair

func _ready() -> void:
	# Set crosshair to be independent of parent transformations
	top_level = true

# Hide all crosshair elements
func _hideAll():
	normalSprite.visible = false
	outerSprite.visible = false
	scopeSprite.visible = false

# Show crosshair with outer ring (for interaction highlighting)
func _showOuter():
	normalSprite.visible = true
	outerSprite.visible = true
	scopeSprite.visible = false

# Show scope crosshair for weapon scoping
func _showScope():
	normalSprite.visible = false
	outerSprite.visible = false
	scopeSprite.visible = true

# Reset to default crosshair state
func _reset():
	normalSprite.visible = true
	outerSprite.visible = false
	scopeSprite.visible = false
