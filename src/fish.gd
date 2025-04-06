extends CharacterBody3D

@export var speed: float = 0.002
@export var turn_speed: float = 0.05
@export var swim_range: float = 5.0  # How far the fish will swim before changing direction

var target_direction: Vector3 = Vector3.ZERO
var time_since_last_turn: float = 0.0
var change_direction_interval: float = 3.0  # Seconds between direction changes

# You may want to set an initial direction or randomize it
func _ready():
	target_direction = Vector3(randf_range(-1.0, 1.0), 0, randf_range(-1.0, 1.0)).normalized()

# Update the fish's swimming behavior
func _process(delta):
	time_since_last_turn += delta

	# Change direction randomly after some time
	if time_since_last_turn >= change_direction_interval:
		time_since_last_turn = 0.0
		target_direction = Vector3(randf_range(-1.0, 1.0), 0, randf_range(-1.0, 1.0)).normalized()

	# Smoothly rotate towards the target direction
	var rotation_target = target_direction.angle_to(Vector3(0, 0, -1))  # Towards the forward direction
	rotation.y = lerp_angle(rotation.y, rotation_target, turn_speed * delta)

	# Move the fish
	velocity = target_direction * speed
	move_and_slide()
