extends Node2D

class_name SnakeBody

@export var body_segment_scene: PackedScene = preload("res://scenes/snake_body_segment.tscn")
@export var max_length = 50

signal move_body_finished

var segments: Array[SnakeBodySegment] = []
var position_history: Array[Vector2] = []

func initialize(initial_pos: Vector2):
	position_history.append(initial_pos)
	grow_body()

func grow_body():
	"""增长身体"""
	var segment = body_segment_scene.instantiate()
	segment.position = position_history[segments.size()]
	call_deferred("add_child", segment)
	segments.append(segment)
	print("Body grew! Total segments: ", segments.size())

func move_body(new_pos: Vector2, duration: float = 0.2):
	if segments.is_empty():
		return
	update_position_history(new_pos)
	animate_front_segments(duration)

func animate_front_segments(duration: float):
	var tween = create_tween()
	for i in range(segments.size()):
		tween.parallel().tween_property(segments[i], "position", position_history[i], duration)
	tween.finished.connect(func(): move_body_finished.emit())


func update_position_history(new_pos: Vector2):
	position_history.push_front(new_pos)
	while position_history.size() > max_length * 2:
		position_history.pop_back()

func get_body_global_positions() -> Array[Vector2]:
	var positions: Array[Vector2] = []
	for i in range(segments.size()):
		positions.append(segments[i].global_position)
	return positions
