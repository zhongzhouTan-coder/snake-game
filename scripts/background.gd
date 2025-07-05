extends Node2D

class_name Background

@export var grid_size: int = 16
@export var grid_width: int = 120
@export var grid_height: int = 68

@onready var wall_layer: TileMapLayer = $Wall
@onready var green_layer: TileMapLayer = $Grid

func _ready() -> void:
	print("Background is ready")

func get_empty_positions() -> Array[Vector2i]:
	"""Get all empty positions in the background grid."""
	var empty_positions: Array[Vector2i] = []
	for x in range(grid_width):
		for y in range(grid_height):
			var pos = Vector2i(x, y)
			if not is_wall_at_position(pos):
				empty_positions.append(pos)
	return empty_positions

func is_wall_at_position(grid_pos: Vector2) -> bool:
	"""Check if there is a wall at the given grid position."""
	if not wall_layer:
		return false
	
	var cell_data = wall_layer.get_cell_source_id(grid_pos)
	return cell_data != -1

# === 必要的坐标转换方法 ===

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	"""将网格坐标转换为世界坐标（网格中心）"""
	return Vector2(
		grid_pos.x * grid_size + grid_size / 2.0,
		grid_pos.y * grid_size + grid_size / 2.0
	)

func world_to_grid(world_pos: Vector2) -> Vector2i:
	"""将世界坐标转换为网格坐标"""
	return Vector2i(
		int(world_pos.x / grid_size),
		int(world_pos.y / grid_size)
	)

func debug_tilemap():
	"""调试 TileMapLayer 内容"""
	if not wall_layer:
		print("No wall layer!")
		return
	
	print("=== TileMapLayer Debug ===")
	var used_cells = wall_layer.get_used_cells()
	print("Used cells count: ", used_cells.size())
	
	for i in range(min(5, used_cells.size())): # 只打印前5个
		var cell = used_cells[i]
		var source_id = wall_layer.get_cell_source_id(cell)
		print("Cell ", cell, ": source_id = ", source_id)
