extends Control
@onready var margin_container: MarginContainer = $MarginContainer
@onready var texture_rect: TextureRect = $TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_try_again_button_pressed() -> void:
	print('clicked')
	SignalBus.restart.emit()
