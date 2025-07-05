extends Node2D

class_name SnakeBody

@export var body_segment_scene: PackedScene = preload("res://scenes/snake_body_segment.tscn")

func create_segment(pos: Vector2) -> SnakeBodySegment:
	"""创建新的身体节点"""
	var segment = body_segment_scene.instantiate()
	segment.global_position = pos
	add_child(segment)
	return segment

func remove_segment(segment: SnakeBodySegment):
	"""移除身体节点"""
	segment.queue_free()

func clear_all():
	"""清空所有身体节点"""
	for child in get_children():
		child.queue_free()
