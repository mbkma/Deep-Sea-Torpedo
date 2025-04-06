extends CharacterBody3D

@export var torpedo_scene: PackedScene
@export var speed: float = 0.1
@export var turn_speed: float = 0.15
@export var vertical_speed: float = 0.05
@export var buoyancy: float = 0.02
@export var max_health: int = 100  # 🆕 Player health
@onready var spot_light_3d: SpotLight3D = $SpotLight3D

@onready var torpedo_spawn = $TorpedoSpawn
@onready var health = max_health  # 🆕 Start at full health

var velocity_vector: Vector3 = Vector3.ZERO
var external_velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float):
	handle_movement(delta)
	apply_buoyancy(delta)
	velocity += external_velocity
	move_and_slide()

func handle_movement(delta: float):
	var move_input = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	var turn_input = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	var vertical_input = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")

	velocity_vector = transform.basis.z * -move_input * speed
	velocity_vector.y += vertical_input * vertical_speed
	rotation.y += turn_input * turn_speed * delta

	velocity = velocity_vector

func apply_buoyancy(delta: float):
	if not is_on_floor():
		velocity_vector.y += buoyancy * delta
		velocity = velocity_vector

func get_mouse_aim_rotation() -> Vector2:
	var viewport_size = get_viewport().size
	var mouse_pos = Vector2(get_viewport().get_mouse_position())  # Cast to Vector2

	# Normalize mouse position relative to center
	var offset = (mouse_pos - Vector2(viewport_size) / 2.0) / Vector2(viewport_size)

	# Scale sensitivity (adjust these values for better control)
	var yaw = -offset.x * PI / 4   # Max ±45° horizontal turn (inverted)
	var pitch = -offset.y * PI / 6  # Max ±30° vertical turn

	return Vector2(pitch, yaw)



### **🚀 Fire Torpedo Towards Mouse Target**
func _input(event):
	if event.is_action_pressed("fire_torpedo"):
		fire_torpedo()
	if event.is_action_pressed("light"):
		spot_light_3d.light_energy = 1.0 if spot_light_3d.light_energy < 0.5 else 0


func fire_torpedo():
	if torpedo_scene:
		var torpedo = torpedo_scene.instantiate()
		get_parent().add_child(torpedo)

		# Set the torpedo's position at the spawn point
		torpedo.global_transform = torpedo_spawn.global_transform

		# Get mouse aiming direction (left/right, up/down)
		var aim_rotation = get_mouse_aim_rotation()
		torpedo.rotate_object_local(Vector3.UP, aim_rotation.y)  # Left/right (Yaw)
		torpedo.rotate_object_local(Vector3.RIGHT, aim_rotation.x)  # Up/down (Pitch)

		# Launch the torpedo straight forward (-Z direction)
		torpedo.launch()


### **🆕 Take Damage Function**
func take_damage(amount: int):
	health -= amount
	print("Player Health:", health)

	if health <= 0:
		explode()

func explode():
	print("💥 Player Submarine Destroyed!")
	queue_free()  # Remove the submarine
