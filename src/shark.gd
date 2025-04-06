extends CharacterBody3D

@export var speed: float = 0.04
@export var detection_range: float = 0.3
@export var attack_range: float = 0.5
@export var wander_radius: float = 0.2  # Area to wander around

var target: Node3D = null
var state: String = "wandering"
var direction: Vector3 = Vector3.ZERO

@onready var raycast = $RayCast3D
@onready var detection_area = $DetectionArea3D


func _physics_process(delta):
	if state == "wandering":
		wander()
	elif state == "chasing":
		chase()
	elif state == "attacking":
		attack()

	#avoid_obstacles()
	velocity = direction * speed
	move_and_slide()

### **1. RANDOM WANDERING**
func wander():
	if global_transform.origin.distance_to(direction) < 2:
		pick_new_wander_target()

### **2. CHASING & ATTACKING**
func chase():
	if target:
		direction = (target.global_transform.origin - global_transform.origin).normalized()
		if global_transform.origin.distance_to(target.global_transform.origin) < attack_range:
			state = "attacking"

func attack():
	if target:
		print("🦈 Shark attacks!")  # Add actual attack logic here

### **3. PICK A NEW RANDOM WANDER TARGET**
func pick_new_wander_target():
	var random_offset = Vector3(
		randf_range(-wander_radius, wander_radius),
		randf_range(-0.05, 0.05),  # Small vertical movement
		randf_range(-wander_radius, wander_radius)
	)
	direction = (global_transform.origin + random_offset - global_transform.origin).normalized()

### **4. OBSTACLE AVOIDANCE USING RAYCAST**
func avoid_obstacles():
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var normal = raycast.get_collision_normal()
		direction = (direction + normal).normalized()

### **5. DETECTION SYSTEM**
func _on_detection_area_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Submarine"):
		target = body
		state = "chasing"
