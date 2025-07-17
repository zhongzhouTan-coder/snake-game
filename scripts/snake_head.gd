extends CharacterBody2D

class_name SnakeHead

@onready var animation_tree: AnimationTree = $AnimationTree

var current_direction = Vector2.ZERO

signal move_head_finished

func initialize(initial_direction: Vector2):
	change_direction(initial_direction)

func move_head(distance: int, move_duration: float = 0.2) -> KinematicCollision2D:
	var collision = move_and_collide(current_direction * distance, true)
	if collision != null:
		return collision
	
	var tween = create_tween()

	tween.tween_property(self, "position", position + current_direction * distance, move_duration)
	tween.finished.connect(func(): move_head_finished.emit())
	return null

func change_direction(direction: Vector2):
	if current_direction == -direction:
		return
	if not animation_tree || current_direction == direction:
		return
	animation_tree.set("parameters/blend_position", direction)
	current_direction = direction
