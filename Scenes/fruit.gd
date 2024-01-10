extends RigidBody2D
const FRUIT = preload("res://Scenes/fruit.tscn")
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label
var size: int = 1
var max_size:int = 11

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		collision_shape_2d.shape.radius = 14 + (size - 1) * 6

func _draw() -> void:
	var color: Color = Color.from_hsv(float(size) / max_size, 1,1)
	draw_circle(Vector2.ZERO, collision_shape_2d.shape.radius, color)
	label.text = str(size)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group('fruits') or is_queued_for_deletion():
		return
	
	var new_fruit_position:Vector2 =  (body.global_position + global_position) / 2
	var height = new_fruit_position.y - body.get_node("CollisionShape2D").get_shape().get_radius()
	SignalBus.collided.emit(height)
	
	if body.size != size:
		return
	body.queue_free()
	queue_free()
	
	if size < max_size:
		var new_fruit: RigidBody2D = FRUIT.instantiate()
		new_fruit.global_position = new_fruit_position
		new_fruit.size = size + 1
		get_parent().call_deferred("add_child", new_fruit)
		
	SignalBus.fruit_combined.emit(size)


func disable_physics()-> void:
	gravity_scale = 0
	collision_layer = 0
	collision_mask = 0

func enable_physics() -> void:
	gravity_scale = 1
	await get_tree().create_timer(0.25).timeout
	collision_layer = 1
	collision_mask = 1
