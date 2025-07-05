extends Node

@onready var background: Background = $Background
@onready var snake_player: SnakePlayer = $SnakePlayer
@onready var food_manager: FoodManager = $FoodManager
@onready var game_timer: Timer = $GameTimer

# === 游戏参数 ===
@export var base_move_interval: float = 0.3
@export var speed_increase_rate: float = 0.1
@export var min_move_interval: float = 0.08

# === 游戏状态 ===
var game_score: int = 0
var is_game_running: bool = false
var current_move_interval: float

# === 游戏事件信号 ===
signal game_started()
signal game_over(final_score: int)
signal score_changed(new_score: int)

func _ready():
	print("Main game scene initialized")

	setup_game()

func setup_game():
	"""初始化游戏"""
	current_move_interval = base_move_interval

	# 设置游戏计时器
	setup_game_timer()
	
	# 连接所有信号
	connect_signals()
	
	# 开始游戏
	start_game()

func setup_game_timer():
	"""设置游戏计时器"""
	game_timer.wait_time = current_move_interval
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.one_shot = false

func connect_signals():
	"""连接所有组件的信号"""
	# 蛇玩家信号
	snake_player.snake_grew.connect(_on_snake_grew)
	snake_player.snake_died.connect(_on_snake_died)
	
	# 食物管理器信号
	food_manager.food_eaten.connect(_on_food_eaten)
	food_manager.food_spawned.connect(_on_food_spawned)
	
	print("All signals connected")

# === 游戏流程控制 ===

func start_game():
	"""开始游戏"""
	print("Starting new game...")
	
	is_game_running = true
	game_score = 0
	
	# 重置游戏状态
	current_move_interval = base_move_interval
	game_timer.wait_time = current_move_interval
	
	# 启动计时器
	game_timer.start()
	
	# 触发初始食物生成
	spawn_initial_food()
	
	game_started.emit()
	score_changed.emit(game_score)

	
func spawn_initial_food():
	"""生成初始食物"""
	# 稍微延迟一下确保蛇完全初始化
	get_tree().create_timer(0.1).timeout.connect(func(): request_spawn_food())

func end_game():
	"""结束游戏"""
	print("Game ended! Final score: ", game_score)
	
	is_game_running = false
	game_timer.stop()
	
	game_over.emit(game_score)

# === 核心游戏循环 ===

func _on_game_timer_timeout():
	"""游戏计时器触发 - 核心游戏循环"""
	if not is_game_running:
		return
	
	# 移动蛇
	if not snake_player.move_snake():
		# 移动失败（撞墙或撞自己）
		end_game()
		return
	
	# 检查是否需要调整游戏速度
	adjust_game_speed()

func adjust_game_speed():
	"""根据分数调整游戏速度"""
	# 每10分增加一次速度
	var speed_level = game_score / 10
	var target_interval = max(min_move_interval, base_move_interval - speed_level * speed_increase_rate)
	
	if abs(target_interval - current_move_interval) > 0.001:
		current_move_interval = target_interval
		game_timer.wait_time = current_move_interval
		print("Speed increased! New interval: ", current_move_interval)

# === 食物系统处理 ===

func request_spawn_food():
	"""处理食物生成请求"""
	if not is_game_running:
		return
	
	print("Processing food spawn request...")
	
	# 获取蛇的所有位置
	var snake_positions = snake_player.get_all_positions()
	
	# 获取有效的食物生成位置
	var valid_positions = get_valid_food_positions(snake_positions)
	
	if valid_positions.is_empty():
		print("Warning: No valid positions for food spawn!")
		# 游戏区域满了，可能需要特殊处理
		return
	
	# 选择随机位置生成食物
	var spawn_position = valid_positions[randi() % valid_positions.size()]
	food_manager.spawn_food_at_grid_position(spawn_position, background)

func get_valid_food_positions(snake_positions: Array[Vector2i]) -> Array[Vector2i]:
	"""获取有效的食物生成位置"""
	var empty_positions = background.get_empty_positions()
	var valid_positions: Array[Vector2i] = []
	
	for pos in empty_positions:
		# 检查是否在蛇身上
		if pos in snake_positions:
			continue
		
		# 可选：检查距离蛇头的最小距离
		if not snake_positions.is_empty():
			var snake_head_pos = snake_positions[0]
			var distance = abs(pos.x - snake_head_pos.x) + abs(pos.y - snake_head_pos.y)
			if distance < food_manager.min_spawn_distance:
				continue
		
		valid_positions.append(pos)
	
	return valid_positions

func _on_food_spawned(grid_position: Vector2i):
	"""食物生成成功"""
	print("Food spawned successfully at: ", grid_position)
	# 可以在这里添加音效、特效等

func _on_food_eaten(food_value: int):
	"""处理食物被吃掉"""
	print("Food eaten! Points gained: ", food_value)
	
	# 更新分数
	game_score += food_value
	score_changed.emit(game_score)
	print("Score updated: ", game_score)

	call_deferred("grow_snake_and_generate_food")


func grow_snake_and_generate_food():
	# 让蛇增长
	snake_player.grow()
	
	request_spawn_food()

# === 蛇系统事件处理 ===

func _on_snake_grew():
	"""蛇增长事件"""
	print("Snake grew! Current total length: ", snake_player.segments.size() + 1)
	
	# 可以在这里添加增长音效、特效等
	# 也可以检查是否达到获胜条件

func _on_snake_died():
	"""蛇死亡事件"""
	print("Snake died!")
	end_game()
