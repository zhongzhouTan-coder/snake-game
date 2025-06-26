extends Node2D

@onready var grid_system = $GridSystem
@onready var grid_renderer = $GridRenderer
@onready var game_timer = $GameTimer

@export var move_speed: float = 0.2

var game_running: bool = true

func _ready():
	# Connect signals
	grid_system.food_eaten.connect(_on_food_eaten)
	grid_system.game_over.connect(_on_game_over)
	
	# Setup timer
	game_timer.wait_time = move_speed
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()

func _input(event):
	if not game_running:
		return
	
	if event.is_action_pressed("ui_up"):
		grid_system.set_snake_direction(Vector2i.UP)
	elif event.is_action_pressed("ui_down"):
		grid_system.set_snake_direction(Vector2i.DOWN)
	elif event.is_action_pressed("ui_left"):
		grid_system.set_snake_direction(Vector2i.LEFT)
	elif event.is_action_pressed("ui_right"):
		grid_system.set_snake_direction(Vector2i.RIGHT)

func _on_game_timer_timeout():
	if game_running:
		grid_system.move_snake()
		grid_renderer._on_grid_updated()

func _on_food_eaten():
	print("Food eaten! Snake length: ", grid_system.get_snake_length())
	# Optionally increase speed
	move_speed = max(0.05, move_speed - 0.01)
	game_timer.wait_time = move_speed

func _on_game_over():
	game_running = false
	game_timer.stop()
	print("Game Over! Final score: ", grid_system.get_snake_length())
