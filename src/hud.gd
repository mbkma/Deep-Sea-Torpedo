extends Control

@onready var player_submarine: CharacterBody3D = $"../PlayerSubmarine"
@onready var label: Label = $AreasLeftLabel
@onready var area_spawner: Node3D = $"../AreaSpawner"
@onready var direction_label_left_right: Label = $VBoxContainer2/DirectionLabelLeftRight
@onready var direction_label_top_down: Label = $VBoxContainer2/DirectionLabelTopDown
@onready var direction_label_forward_backward: Label = $VBoxContainer2/DirectionLabelForwardBackward

func _ready() -> void:
	update_areas_left(0,0)
	area_spawner.game_won.connect(_on_game_won)


func _process(delta: float) -> void:
	if area_spawner.last_area_position:
		var target: Vector3 = player_submarine.global_position-area_spawner.last_area_position
		print(target)
		direction_label_top_down.text = "Down" if target.y > 0 else "Top"
		direction_label_left_right.text = "Left" if target.x > 0 else "Right"
		direction_label_forward_backward.text = "Forward" if target.z > 0 else "Backward"

func update_areas_left(count: int, total: int):
	label.text = "Areas Left: " + str(total-count)


func _on_game_won():
	$VBoxContainer.show()


func _on_button_2_pressed() -> void:
	get_tree().quit()
