extends Node3D

@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	cpu_particles_3d.emitting = true
	audio_stream_player_3d.play()
