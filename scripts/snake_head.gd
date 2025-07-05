extends CharacterBody2D

class_name SnakeHead

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func move_by_direction(direction: Vector2, speed: float, delta: float) -> bool:
	"""执行移动，返回是否成功"""
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	return collision == null
