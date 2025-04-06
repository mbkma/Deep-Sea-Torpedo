extends Node3D

@export var fish_scene: PackedScene  # Drag your Fish scene here
@export var spawn_area_size: Vector3 = Vector3(10, 2, 10)  # Define the spawn area (width, height, depth)
@export var num_fish: int = 10  # Number of fish to spawn

func _ready():
	# Start spawning fish periodically
	_spawn_fish(num_fish)

func _spawn_fish(amount: int):
	# Spawn the fish at random positions within the spawn area
	for i in range(amount):
		var random_position = Vector3(
			randf_range(-spawn_area_size.x / 2, spawn_area_size.x / 2),
			randf_range(0.5, spawn_area_size.y),
			randf_range(-spawn_area_size.z / 2, spawn_area_size.z / 2)
		)

		var fish = fish_scene.instantiate()
		add_child(fish)  # Add the fish to the scene
		fish.global_transform.origin = random_position  # Set random spawn position
