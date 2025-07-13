extends Node

@onready var background: Background = $Background
@onready var snake_player: SnakePlayer = $SnakePlayer
@onready var food_manager: FoodManager = $FoodManager

var game_score: int = 0
var is_game_running: bool = false
var move_interval: float = 0.5
var accumulate_time: float = 0.0

signal game_started()
signal game_over(final_score: int)
signal score_changed(new_score: int)

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
	game_score = 0
	game_started.emit()
	score_changed.emit(game_score)

func end_game():
	print("Game ended! Final score: ", game_score)
	is_game_running = false
	game_over.emit(game_score)


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

func _on_food_eaten(food_value: int):
	print("Food eaten! Points gained: ", food_value)
	game_score += food_value
	score_changed.emit(game_score)
	print("Score updated: ", game_score)
	snake_player.grow()
	move_interval = max(0.02, move_interval * pow(0.9, game_score / 10))

func _on_snake_died():
	print("Snake died!")
	end_game()
