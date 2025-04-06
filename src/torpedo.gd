extends RigidBody3D

@export var speed: float = 0.8
@export var damage: int = 25
@export var lifetime: float = 5.0
@export var explosion_effect: PackedScene  # Reference to the explosion effect scene

### **🚀 Launch Torpedo (Always Moves Forward)**
func launch():
	$AudioStreamPlayer3D.play()
	linear_velocity = -global_transform.basis.z * speed  # Always move forward
	await get_tree().create_timer(lifetime).timeout
	queue_free()

### **💥 Collision Detection**
func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body)
	if body.is_in_group("Destroyable"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		if explosion_effect:
			var explosion = explosion_effect.instantiate()
			explosion.global_transform = global_transform  # Position the explosion at the torpedo's location
			get_parent().add_child(explosion)  # Add the explosion to the scene
		queue_free()  # Destroy torpedo
