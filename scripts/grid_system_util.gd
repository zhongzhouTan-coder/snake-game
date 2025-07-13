extends Node

class_name GridSystemUtil

@export_group("Grid Settings")
@export var grid_size: int = 16
@export var grid_width: int = 50
@export var grid_height: int = 38

static var instance: GridSystemUtil

func _ready() -> void:
	instance = self

func get_grid_size() -> int:
	return instance.grid_size

func get_grid_width() -> int:
	return instance.grid_width

func get_grid_height() -> int:
	return instance.grid_height

func grid_to_world(grid_pos: Vector2) -> Vector2:
	var world_pos = Vector2(
		grid_pos.x * get_grid_size() + get_grid_size() * 0.5,
		grid_pos.y * get_grid_size() + get_grid_size() * 0.5
	)
	return world_pos

func batch_grid_to_world(grid_positions: Array[Vector2]) -> Array[Vector2]:
	var world_positions: Array[Vector2] = []
	for grid_pos in grid_positions:
		world_positions.append(grid_to_world(grid_pos))
	return world_positions

func world_to_grid(world_pos: Vector2) -> Vector2:
	var grid_pos = Vector2(
		world_pos.x / get_grid_size(),
		world_pos.y / get_grid_size()
	)
	return grid_pos

func batch_world_to_grid(world_positions: Array[Vector2]) -> Array[Vector2]:
	var grid_positions: Array[Vector2] = []
	for world_pos in world_positions:
		grid_positions.append(world_to_grid(world_pos))
	return grid_positions
