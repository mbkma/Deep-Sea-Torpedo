extends Node3D

@onready var area_spawner: Node3D = $AreaSpawner

func _ready() -> void:
	$AudioStreamPlayer.play()
