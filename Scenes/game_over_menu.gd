extends Control
@onready var game_scene: Node2D = $".."


func _on_restart_pressed() -> void:
	game_scene.restart()

func _on_quit_pressed() -> void:
	get_tree().quit()
