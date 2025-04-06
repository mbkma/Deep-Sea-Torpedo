extends Node3D

signal game_won

@export var area_scene: PackedScene  # Drag and drop your Area scene here
@export var num_areas: int = 5  # Number of areas to spawn
@export var hud: Node  # Drag the HUD here in the Inspector
var current_area_count = 0
var last_area_position = Vector3(0,0.5,4)  # Start position

func _ready():
	spawn_next_area()  # Start with the first area

func spawn_next_area():
	if current_area_count >= num_areas:
		hud.update_areas_left(current_area_count, num_areas)
		game_won.emit()
		return  # Stop if all areas have been spawned
	hud.update_areas_left(current_area_count, num_areas)

	if area_scene:
		var area = area_scene.instantiate()
		add_child(area)
		area.global_transform.origin = last_area_position + Vector3(randf_range(0.5, 0.5), randf_range(-0.2, 1), randf_range(-0.4, -0.6))
		last_area_position = area.global_transform.origin  # Store last position
		current_area_count += 1
		# Connect signal so the next area spawns when the player enters
		if area.has_signal("player_passed"):
			area.connect("player_passed", spawn_next_area)  # Trigger next area when player passes
