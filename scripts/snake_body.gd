extends Node2D

class_name SnakeBody

@export var body_segment_scene: PackedScene = preload("res://scenes/snake_body_segment.tscn")
@export var max_length = 50

var segments: Array[SnakeBodySegment] = []
var position_history: Array[Vector2] = []

func initialize(initial_pos: Vector2):
	position_history.append(initial_pos)
	grow_body()

func grow_body():
	"""增长身体"""
	var segment = body_segment_scene.instantiate()
	segment.position = position_history[segments.size()]
	add_child(segment)
	segments.append(segment)
	print("Body grew! Total segments: ", segments.size())

func move_body(new_pos: Vector2, duration: float = 0.2):
	if segments.is_empty():
		return
	update_position_history(new_pos)

	var animated_count = min(3, segments.size())
	animate_front_segments(animated_count, duration)
	update_back_segments_immediately(animated_count)

func animate_front_segments(count: int, duration: float):
	for i in range(count):
		var tween = create_tween()
		var delay = i * 0.03
		if delay > 0:
			tween.tween_interval(delay)
		tween.tween_property(segments[i], "position", position_history[i], duration)


func update_position_history(new_pos: Vector2):
	"""更新位置历史"""
	position_history.push_front(new_pos)
	while position_history.size() > max_length * 2:
		position_history.pop_back()

func update_back_segments_immediately(skip_count: int):
	for i in range(skip_count, segments.size()):
		segments[i].position = position_history[i]

func get_body_global_positions() -> Array[Vector2]:
	var positions: Array[Vector2] = []
	for i in range(segments.size()):
		positions.append(segments[i].global_position)
	return positions
