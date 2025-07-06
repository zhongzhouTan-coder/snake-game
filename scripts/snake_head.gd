extends CharacterBody2D

class_name SnakeHead

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_tree: AnimationTree = $AnimationTree

var current_direction = Vector2.RIGHT

func _ready() -> void:
	if animation_tree:
		animation_tree.active = true
		_set_blend_position(current_direction)


func move_by_direction(direction: Vector2, speed: float, delta: float) -> bool:
	"""执行移动，返回是否成功"""
	_set_blend_position(direction)
	current_direction = direction
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	return collision == null

func _set_blend_position(direction: Vector2):
	if animation_tree && current_direction != direction:
		animation_tree.set("parameters/blend_position", direction)
	
