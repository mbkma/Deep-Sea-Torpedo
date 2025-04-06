extends CharacterBody3D

@export var torpedo_scene: PackedScene  # Drag and drop torpedo scene here
@export var speed: float = 0.03
@export var turn_speed: float = 1
@export var fire_range: float = 1.0  # Distance to fire torpedoes
@export var submarine_distance: float = 0.5
@export var detection_range: float = 20.0  # Distance to detect player
@export var buoyancy: float = 0.02
@export var max_health: int = 100  # 🆕 Health for enemy submarine
@export var explosion_effect: PackedScene  # Reference to the explosion effect scene


@onready var torpedo_spawn = $TorpedoSpawn
@onready var sonar_area = $SonarArea  # Detects the player
@onready var health = max_health  # 🆕 Start at full health

var velocity_vector: Vector3 = Vector3.ZERO
var external_velocity: Vector3 = Vector3.ZERO
var player: CharacterBody3D = null  # Player reference
var patrolling: bool = true  # Start by patrolling

func _ready():
	sonar_area.connect("body_entered", _on_sonar_detected)
	sonar_area.connect("body_exited", _on_sonar_lost)

func _physics_process(delta: float):
	if player:
		chase_player(delta)
	else:
		patrol_area(delta)

	apply_buoyancy(delta)
	velocity += external_velocity
	move_and_slide()

### **1. Patrolling Behavior**
func patrol_area(delta: float):
	velocity_vector = transform.basis.z * -speed  # Move forward
	if randi() % 200 == 0:  # Randomly turn sometimes
		rotation.y += (randf() - 0.5) * turn_speed * delta
	velocity = velocity_vector

### **2. Chasing the Player**
func chase_player(delta: float):
	if player:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()

		# Rotate towards player
		var target_rotation = atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, turn_speed * delta)

		print(global_transform.origin.distance_to(player.global_transform.origin))
		if global_transform.origin.distance_to(player.global_transform.origin) > submarine_distance:
			# Move forward
			velocity_vector = transform.basis.z * -speed
		else:
			velocity_vector = Vector3.ZERO

		# Fire torpedoes if close enough
		if global_transform.origin.distance_to(player.global_transform.origin) < fire_range:
			fire_torpedo()

		velocity = velocity_vector

### **3. Buoyancy Effect**
func apply_buoyancy(delta: float):
	velocity_vector.y += buoyancy * delta
	velocity = velocity_vector

var cooldown := false
### **4. Torpedo Attack**
func fire_torpedo():
	if torpedo_scene and not cooldown:
		var torpedo = torpedo_scene.instantiate()
		get_parent().add_child(torpedo)
		torpedo.global_transform = torpedo_spawn.global_transform
		torpedo.launch()
		cooldown = true
		await get_tree().create_timer(1).timeout
		cooldown = false

### **5. Take Damage from Torpedoes**
func take_damage(amount: int):
	health -= amount
	print("Enemy Health:", health)
	player = get_parent().get_parent().get_node("PlayerSubmarine")
	patrolling = false
	if health <= 0:
		explode()

### **6. Explode When Destroyed**
func explode():
	var explosion = explosion_effect.instantiate()
	explosion.global_transform = global_transform
	get_parent().add_child(explosion)
	var particles = explosion.cpu_particles_3d as CPUParticles3D
	particles.lifetime = 0.5
	print("💥 Enemy Submarine Destroyed!")
	queue_free()  # Remove enemy submarine

### **7. Sonar Detection (Detects Player)**
func _on_sonar_detected(body):
	if body.name == "PlayerSubmarine":
		player = body
		patrolling = false

func _on_sonar_lost(body):
	if body == player:
		player = null
		patrolling = true
