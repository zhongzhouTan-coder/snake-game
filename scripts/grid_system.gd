extends Node2D
class_name GridSystem

# Grid properties
@export var grid_width: int = 20
@export var grid_height: int = 15
@export var cell_size: int = 32

# Grid data
var grid: Array = []
var snake_positions: Array = []
var food_position: Vector2i
var snake_direction: Vector2i = Vector2i.RIGHT

# Cell types
enum CellType {
	EMPTY,
	SNAKE_HEAD,
	SNAKE_BODY,
	FOOD
}

# Signals
signal food_eaten
signal game_over

func _ready():
	initialize_grid()
	spawn_initial_snake()
	spawn_food()

func initialize_grid():
	"""Initialize the grid with empty cells"""
	grid.clear()
	for y in range(grid_height):
		var row = []
		for x in range(grid_width):
			row.append(CellType.EMPTY)
		grid.append(row)

func spawn_initial_snake():
	"""Spawn snake at the center of the grid"""
	var center_x = grid_width / 2
	var center_y = grid_height / 2
	
	# Initial snake with 3 segments
	snake_positions = [
		Vector2i(center_x, center_y),
		Vector2i(center_x - 1, center_y),
		Vector2i(center_x - 2, center_y)
	]
	
	update_snake_on_grid()

func update_snake_on_grid():
	"""Update the grid with current snake positions"""
	# Clear previous snake positions
	for y in range(grid_height):
		for x in range(grid_width):
			if grid[y][x] == CellType.SNAKE_HEAD or grid[y][x] == CellType.SNAKE_BODY:
				grid[y][x] = CellType.EMPTY
	
	# Set new snake positions
	for i in range(snake_positions.size()):
		var pos = snake_positions[i]
		if is_valid_position(pos):
			if i == 0:
				grid[pos.y][pos.x] = CellType.SNAKE_HEAD
			else:
				grid[pos.y][pos.x] = CellType.SNAKE_BODY

func move_snake():
	"""Move the snake one step forward"""
	var head = snake_positions[0]
	var new_head = head + snake_direction
	
	# Check boundaries
	if not is_valid_position(new_head):
		emit_signal("game_over")
		return false
	
	# Check self collision
	if new_head in snake_positions:
		emit_signal("game_over")
		return false
	
	# Add new head
	snake_positions.insert(0, new_head)
	
	# Check if food is eaten
	if new_head == food_position:
		emit_signal("food_eaten")
		spawn_food()
	else:
		# Remove tail if no food eaten
		snake_positions.pop_back()
	
	update_snake_on_grid()
	return true

func spawn_food():
	"""Spawn food at a random empty position"""
	var empty_positions = []
	
	for y in range(grid_height):
		for x in range(grid_width):
			var pos = Vector2i(x, y)
			if grid[y][x] == CellType.EMPTY and pos not in snake_positions:
				empty_positions.append(pos)
	
	if empty_positions.size() > 0:
		food_position = empty_positions[randi() % empty_positions.size()]
		grid[food_position.y][food_position.x] = CellType.FOOD

func get_snake_direction() -> Vector2i:
	"""Get the current direction the snake is moving"""
	return snake_direction

func set_snake_direction(new_direction: Vector2i):
	"""Set snake direction, preventing reverse movement"""
	if new_direction + snake_direction != Vector2i.ZERO:
		snake_direction = new_direction

func is_valid_position(pos: Vector2i) -> bool:
	"""Check if position is within grid boundaries"""
	return pos.x >= 0 and pos.x < grid_width and pos.y >= 0 and pos.y < grid_height

func get_cell_type(pos: Vector2i) -> CellType:
	"""Get the type of cell at given position"""
	if is_valid_position(pos):
		return grid[pos.y][pos.x]
	return CellType.EMPTY

func world_to_grid(world_pos: Vector2) -> Vector2i:
	"""Convert world position to grid coordinates"""
	return Vector2i(int(world_pos.x / cell_size), int(world_pos.y / cell_size))

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	"""Convert grid coordinates to world position"""
	return Vector2(grid_pos.x * cell_size, grid_pos.y * cell_size)

func get_grid_size() -> Vector2i:
	"""Get the size of the grid"""
	return Vector2i(grid_width, grid_height)

func get_snake_length() -> int:
	"""Get current snake length"""
	return snake_positions.size()
