extends Area3D

signal player_passed  # Signal to tell spawner the player moved through

var passed = false

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "PlayerSubmarine" and not passed:  # Check if the player entered
		$AudioStreamPlayer3D.play()
		player_passed.emit()  # Notify the spawner
		passed = true
		visible = false
