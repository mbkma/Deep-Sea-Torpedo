extends Area3D

@export var current_direction: Vector3 = Vector3(1, 0, 1)  # Default: moves right
@export var strength: float = 0.02  # Strength of the current
@export var direction_change_interval: float = 10.0  # Interval for changing direction in seconds
@export var direction_variation_range: float = 0.2  # How much the direction can vary
@export var smoothness: float = 0.5  # Smoothness factor for the transition

var affected_objects = []

# Timer for direction change
var direction_change_timer: Timer

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

	# Start the timer to change the direction periodically
	start_direction_change_timer()

# Timer to change the current direction periodically
func start_direction_change_timer():
	direction_change_timer = Timer.new()
	direction_change_timer.wait_time = direction_change_interval
	direction_change_timer.one_shot = false
	direction_change_timer.timeout.connect(_on_direction_change)
	add_child(direction_change_timer)
	direction_change_timer.start()

# Function to change the current direction
func change_current_direction():
	# Randomize direction within a given range
	var new_direction = Vector3(
		randf_range(-1.0, 1.0) * direction_variation_range,
		0,
		randf_range(-1.0, 1.0) * direction_variation_range
	).normalized()

	# Smooth transition between current direction and new direction
	current_direction = current_direction.lerp(new_direction, smoothness)

func _on_direction_change():
	# Change the current direction smoothly
	change_current_direction()

func _on_body_entered(body):
	if body is CharacterBody3D or body is RigidBody3D:
		affected_objects.append(body)

func _on_body_exited(body):
	affected_objects.erase(body)

func _process(delta):
	for obj in affected_objects:
		if obj is CharacterBody3D:
			if "external_velocity" in obj:
				obj.external_velocity = current_direction * strength  # Apply current to object
		elif obj is RigidBody3D:
			obj.apply_central_impulse(current_direction * strength * delta)  # Apply current to rigidbody
