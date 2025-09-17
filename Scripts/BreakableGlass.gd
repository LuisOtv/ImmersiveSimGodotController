extends StaticBody3D

# Audio and particle components
@onready var breakSound: AudioStreamPlayer3D = $Break
@onready var particles: GPUParticles3D = $GPUParticles3D

# Method to handle glass breaking
func _break():
	# Start particle emission
	particles.emitting = true
	# Play breaking sound
	breakSound.play()
	# Move particles and sound to scene to persist after object destruction
	particles.reparent(get_tree().current_scene, true)
	breakSound.reparent(get_tree().current_scene, true)
	# Remove the glass object
	queue_free()
