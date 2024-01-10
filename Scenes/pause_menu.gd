extends Control
@onready var game_scene: Node2D = $".."

func _on_resume_pressed() -> void:
	game_scene.pauseMenu()

func _on_quit_pressed() -> void:
	get_tree().quit()
