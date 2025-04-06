extends Node3D

@export var enemy_scene: PackedScene  # Drag and drop your EnemySubmarine scene here
@export var spawn_area_size: Vector3 = Vector3(3, 3, 3)  # Define the spawn area (width, height, depth)
@export var num_enemies: int = 20  # Number of enemies to spawn initially
@export var spawn_interval: float = 10.0  # Time interval for spawning new enemies

func _ready():
	_spawn_enemies(num_enemies)
	# Start a timer to spawn enemies periodically
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(_spawn_enemy)
	add_child(timer)

func _spawn_enemies(amount: int):
	for i in range(amount):
		_spawn_enemy()

func _spawn_enemy():
	if enemy_scene:
		var random_position = Vector3(
			randf_range(-spawn_area_size.x / 2, spawn_area_size.x / 2),
			randf_range(1, spawn_area_size.y),
			randf_range(-spawn_area_size.z / 2, spawn_area_size.z / 2)
		)

		var enemy = enemy_scene.instantiate()
		add_child(enemy)  # Add the enemy to the scene
		enemy.global_transform.origin = random_position  # Set random spawn position
