extends Node2D

class_name Background


@onready var wall_layer: TileMapLayer = $Wall
@onready var green_layer: TileMapLayer = $Grid

var empty_positions: Array[Vector2] = []

func _ready() -> void:
	var grid_width = GridSystem.get_grid_width()
	var grid_height = GridSystem.get_grid_height()
	for x in range(grid_width):
		for y in range(grid_height):
			var pos = Vector2(x, y)
			if not is_wall_at_position(pos):
				empty_positions.append(pos)

func get_empty_grid_positions() -> Array[Vector2]:
	"""Get all empty positions in the background grid."""
	return empty_positions

func is_wall_at_position(grid_pos: Vector2) -> bool:
	"""Check if there is a wall at the given grid position."""
	if not wall_layer:
		return false
	
	var cell_data = wall_layer.get_cell_source_id(grid_pos)
	return cell_data != -1
