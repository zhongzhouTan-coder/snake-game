extends Node2D

class_name SnakePlayer

@onready var snake_head: SnakeHead = $SnakeHead
@onready var snake_body: SnakeBody = $SnakeBody

# 游戏参数
@export var move_speed: float = 200.0
@export var grid_size: int = 16
@export var initial_length: int = 3

# 状态管理
var current_direction: Vector2 = Vector2.RIGHT
var next_direction: Vector2 = Vector2.RIGHT
var segments: Array[SnakeBodySegment] = []
var position_history: Array[Vector2] = []

signal snake_grew()
signal snake_died()

func _ready():
	pass

func _input(event):
	"""处理输入"""
	if event.is_action_pressed("ui_up"):
		_set_direction(Vector2.UP)
	elif event.is_action_pressed("ui_down"):
		_set_direction(Vector2.DOWN)
	elif event.is_action_pressed("ui_left"):
		_set_direction(Vector2.LEFT)
	elif event.is_action_pressed("ui_right"):
		_set_direction(Vector2.RIGHT)

func _set_direction(new_direction: Vector2):
	"""设置移动方向"""
	if new_direction + current_direction != Vector2.ZERO:
		next_direction = new_direction

func move_snake() -> bool:
	"""执行一步移动，返回是否成功"""
	# 更新方向
	current_direction = next_direction

	# 记录当前位置
	position_history.push_front(snake_head.global_position)
	_limit_position_history()

	# 移动蛇头
	if not snake_head.move_by_direction(current_direction, grid_size, 1.0):
		snake_died.emit()
		return false
	
	# 更新身体跟随
	_update_body_following()

	return true

func _update_body_following():
	"""更新身体跟随蛇头"""
	if segments.is_empty():
		return
	
	for i in range(segments.size()):
		var segment = segments[i]
		var target_history_index = i + 1
		if target_history_index < position_history.size():
			segment.global_position = position_history[target_history_index]

func _limit_position_history():
	"""限制位置历史大小"""
	var max_history = max(50, segments.size() * 10)
	while position_history.size() > max_history:
		position_history.pop_back()

func grow():
	"""增长身体"""
	var pos = _get_spawn_position_for_new_segment();
	var new_segment = snake_body.create_segment(pos)
	if new_segment:
		segments.append(new_segment)
		snake_grew.emit()

func _get_spawn_position_for_new_segment() -> Vector2:
	"""获取新身体节点的生成位置"""
	if segments.size() > 0:
		# 放在最后一个身体节点的位置
		return segments[-1].global_position
	elif position_history.size() > 0:
		# 如果没有身体节点，放在历史位置的最后
		return position_history[-1]
	else:
		# fallback: 放在蛇头后面
		return snake_head.global_position - current_direction * grid_size

func get_all_positions() -> Array[Vector2i]:
	"""获取蛇的所有位置（网格坐标）"""
	var positions: Array[Vector2i] = []
	
	# 蛇头位置
	var head_grid_pos = Vector2i(
		int(snake_head.global_position.x / grid_size),
		int(snake_head.global_position.y / grid_size)
	)
	positions.append(head_grid_pos)
	
	# 身体位置
	for segment in segments:
		var segment_grid_pos = Vector2i(
			int(segment.global_position.x / grid_size),
			int(segment.global_position.y / grid_size)
		)
		positions.append(segment_grid_pos)
	
	return positions
