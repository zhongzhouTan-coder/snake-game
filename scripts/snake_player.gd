extends Node2D

class_name SnakePlayer

@onready var snake_head: SnakeHead = $SnakeHead
@onready var snake_body: SnakeBody = $SnakeBody

var is_moving: bool = false

signal snake_died()

func _ready():
	snake_head.initialize(Vector2.RIGHT)
	snake_body.initialize(snake_head.position + Vector2.LEFT * 16)

func change_direction(new_direction: Vector2):
	snake_head.change_direction(new_direction)

func move(duration: float):
	if is_moving:
		return
	is_moving = true
	var original_pos = snake_head.position
	var collision = snake_head.move_head(16, duration)
	if collision != null:
		snake_died.emit()
		print("snake collide with: ", collision.get_collider())
		return
	snake_body.move_body(original_pos, duration)
	get_tree().create_timer(duration + 0.01).timeout.connect(func(): is_moving = false)

func grow():
	snake_body.grow_body()

func get_snake_grid_positions() -> Array[Vector2]:
	var body_positions = snake_body.get_body_global_positions()
	body_positions.append(snake_head.global_position)
	return GridSystem.batch_world_to_grid(body_positions)
