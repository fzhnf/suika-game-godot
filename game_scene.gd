extends Node2D

const FRUIT = preload("res://Scenes/fruit.tscn")
@onready var next_fruit_marker: Marker2D = $NextFruitMarker
@onready var left_marker: Marker2D = $LeftMarker
@onready var right_marker: Marker2D = $RightMarker
@onready var top_marker: Marker2D = $TopMarker
@onready var game_lost_label: Label = $GameLostLabel

var current_fruit: RigidBody2D
var next_fruit: RigidBody2D
var is_over: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_fruit = create_fruit((left_marker.global_position + right_marker.global_position)/2)
	next_fruit = create_fruit(next_fruit_marker.global_position)
	SignalBus.collided.connect(detect_game_over)
	pass
	
func _physics_process(_delta: float) -> void:
	if is_over:
		return
	if current_fruit != null:
		if current_fruit.gravity_scale == 0:
			current_fruit.global_position.x = get_fruit_x()
			current_fruit.global_position.y = left_marker.global_position.y
		if Input.is_action_just_pressed("click"):
			drop_fruit()

func create_fruit(pos: Vector2) -> RigidBody2D:
	var new_fruit: RigidBody2D = FRUIT.instantiate()
	new_fruit.global_position = pos
	new_fruit.disable_physics()
	new_fruit.size = randi_range(1,5)
	add_child(new_fruit)
	return new_fruit
	
func drop_fruit() -> void:
	current_fruit.enable_physics()
	current_fruit = null
	await get_tree().create_timer(0.25).timeout
	current_fruit = next_fruit
	next_fruit = create_fruit(next_fruit_marker.global_position)
	
func get_fruit_x()-> float:
	var left_marker_x:float = left_marker.global_position.x
	var right_marker_x:float = right_marker.global_position.x
	if current_fruit != null:
		left_marker_x += current_fruit.get_child(0).get_shape().get_radius()
		right_marker_x -= current_fruit.get_child(0).get_shape().get_radius()
	return clamp (
			get_global_mouse_position().x,
			left_marker_x,
			right_marker_x
		)

func detect_game_over(height:float) -> void:
	if height < top_marker.global_position.y:
		is_over = true
		game_lost_label.visible = true
		await get_tree().create_timer(4).timeout
		SignalBus.game_result.emit()
		if get_tree():
			get_tree().reload_current_scene()
