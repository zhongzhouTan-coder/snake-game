extends Node

@onready var background: Background = $Background
@onready var snake_player: SnakePlayer = $SnakePlayer
@onready var food_manager: FoodManager = $FoodManager

var is_game_running: bool = false
var move_interval: float = 0.2
var accumulate_time: float = 0.0

signal game_started()

func _ready():
	food_manager.initialize(self.food_pos_generator)
	connect_signals()
	start_game()

func _process(delta: float) -> void:
	if !is_game_running:
		return
	accumulate_time += delta
	if accumulate_time < move_interval:
		return
	accumulate_time = 0.0
	snake_player.move(move_interval)

func _input(event):
	if !is_game_running:
		return
	if event.is_action_pressed("ui_up"):
		snake_player.change_direction(Vector2.UP)
	elif event.is_action_pressed("ui_down"):
		snake_player.change_direction(Vector2.DOWN)
	elif event.is_action_pressed("ui_left"):
		snake_player.change_direction(Vector2.LEFT)
	elif event.is_action_pressed("ui_right"):
		snake_player.change_direction(Vector2.RIGHT)

func connect_signals():
	snake_player.snake_died.connect(_on_snake_died)
	food_manager.food_eaten.connect(_on_food_eaten)

func start_game():
	is_game_running = true
	game_started.emit()

func end_game():
	is_game_running = false


func food_pos_generator() -> Vector2:
	var empty_positions = background.get_empty_grid_positions()
	var snake_positions = snake_player.get_snake_grid_positions()
	var valid_positions = empty_positions.filter(func(pos):
		return not snake_positions.has(pos)
	)
	if valid_positions.is_empty():
		print("No valid positions for food spawn!")
		return Vector2.ZERO
	var spawn_position = valid_positions[randi_range(0, valid_positions.size() - 1)]
	return GridSystem.grid_to_world(spawn_position)

func _on_food_eaten(value: float):
	print("Food eaten! Points gained: ", value)
	PlayerData.increase_player_score(value)
	move_interval = calculate_move_interval()
	PlayerData.update_player_speed(1 / move_interval)
	food_manager.free_food()
	food_manager.spawn_food()
	snake_player.grow()

func calculate_move_interval() -> float:
	var score = PlayerData.player_score
	return max(0.01, move_interval * pow(0.9, score / 100))

func _on_snake_died():
	print("Snake died!")
	end_game()
