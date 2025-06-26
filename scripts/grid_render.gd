extends Node2D
class_name GridRenderer

@export var grid_system: GridSystem
@export var background_color: Color = Color.BLACK
@export var grid_line_color: Color = Color.GRAY
@export var snake_head_color: Color = Color.GREEN
@export var snake_body_color: Color = Color.DARK_GREEN
@export var food_color: Color = Color.RED
@export var show_grid_lines: bool = true

func _ready():
	if not grid_system:
		grid_system = get_parent().get_node("GridSystem")

func _draw():
	if not grid_system:
		return
	
	var grid_size = grid_system.get_grid_size()
	var cell_size = grid_system.cell_size
	
	# Draw background
	draw_rect(Rect2(0, 0, grid_size.x * cell_size, grid_size.y * cell_size), background_color)
	
	# Draw grid lines
	if show_grid_lines:
		draw_grid_lines(grid_size, cell_size)
	
	# Draw cells
	draw_cells(grid_size, cell_size)

func draw_grid_lines(grid_size: Vector2i, cell_size: int):
	"""Draw grid lines"""
	# Vertical lines
	for x in range(grid_size.x + 1):
		var start = Vector2(x * cell_size, 0)
		var end = Vector2(x * cell_size, grid_size.y * cell_size)
		draw_line(start, end, grid_line_color, 1.0)
	
	# Horizontal lines
	for y in range(grid_size.y + 1):
		var start = Vector2(0, y * cell_size)
		var end = Vector2(grid_size.x * cell_size, y * cell_size)
		draw_line(start, end, grid_line_color, 1.0)

func draw_cells(grid_size: Vector2i, cell_size: int):
	"""Draw all cells based on their type"""
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var pos = Vector2i(x, y)
			var cell_type = grid_system.get_cell_type(pos)
			var world_pos = grid_system.grid_to_world(pos)
			var rect = Rect2(world_pos.x + 1, world_pos.y + 1, cell_size - 2, cell_size - 2)
			
			match cell_type:
				GridSystem.CellType.SNAKE_HEAD:
					draw_rect(rect, snake_head_color)
				GridSystem.CellType.SNAKE_BODY:
					draw_rect(rect, snake_body_color)
				GridSystem.CellType.FOOD:
					draw_rect(rect, food_color)

func _on_grid_updated():
	"""Called when grid needs to be redrawn"""
	queue_redraw()
