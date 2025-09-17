extends RigidBody3D

# Visual effects components
@onready var particles: GPUParticles3D = $GPUParticles3D

# Handle bullet collision with different object types
func _on_area_3d_body_entered(body: Node3D) -> void:
	# Check if object can be broken
	if body.is_in_group("Breakable"):
		body._break()
	# Check if hit a wall
	elif body.is_in_group("Wall"):
		# Create impact particles
		particles.emitting = true
		particles.reparent(get_tree().current_scene, true)
	
	# Destroy bullet after impact
	queue_free()
