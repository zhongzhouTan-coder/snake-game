extends Node2D
class_name GridRenderer

@export var grid_system: GridSystem
@export var background_color: Color = Color.BLACK
@export var grid_line_color: Color = Color.GRAY
@export var snake_head_color: Color = Color.GREEN
@export var snake_body_color: Color = Color.DARK_GREEN
@export var food_color: Color = Color.RED
@export var show_grid_lines: bool = true

# Texture system
@export var use_textures: bool = true
@export_enum("Default", "Scales", "Stripes", "Rainbow", "Gradient") var snake_skin: String = "Default"

var snake_head_textures: Dictionary = {}
var snake_body_textures: Dictionary = {}
var snake_head: SnakeHead = null

func _ready():
	if not grid_system:
		grid_system = get_parent().get_node("GridSystem")
	
	# load textures
	_load_texture_files()

	# create a SnakeHead instance
	if use_textures:
		snake_head = SnakeHead.new()
		add_child(snake_head)

func _load_texture_files():
	"""Load texture files from assets/textures folder"""
	var texture_path = "res://assets/textures/"
	var dir = DirAccess.open(texture_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".png") or file_name.ends_with(".jpg"):
				var texture = load(texture_path + file_name)
				if texture:
					if file_name.begins_with("snake_head_"):
						var skin_name = file_name.replace("snake_head_", "").replace(".png", "").replace(".jpg", "")
						snake_head_textures[skin_name.capitalize()] = texture
					elif file_name.begins_with("snake_body_"):
						var skin_name = file_name.replace("snake_body_", "").replace(".png", "").replace(".jpg", "")
						snake_body_textures[skin_name.capitalize()] = texture
			file_name = dir.get_next()

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
					_update_snake_head(rect)
				GridSystem.CellType.SNAKE_BODY:
					_draw_snake_body(rect)
				GridSystem.CellType.FOOD:
					draw_rect(rect, food_color)

func _update_snake_head(rect: Rect2):
	"""Draw the snake head with texture or fallback color"""
	if use_textures and snake_head:
		var texture = snake_head_textures.get(snake_skin)
		if texture:
			snake_head.set_texture(texture)
			snake_head.set_position(rect.position + rect.size / 2)
			match grid_system.get_snake_direction():
				Vector2i.UP:
					snake_head.set_rotation(0.0)
				Vector2i.DOWN:
					snake_head.set_rotation(PI)
				Vector2i.LEFT:
					snake_head.set_rotation(-PI / 2)
				Vector2i.RIGHT:
					snake_head.set_rotation(PI / 2)
		else:
			# Fallback to solid color if texture not found
			draw_rect(rect, snake_head_color)

func _draw_snake_body(rect: Rect2):
	"""Draw a snake body with texture or fallback color"""
	if use_textures:
		var texture = snake_body_textures.get(snake_skin)
		if texture:
			draw_texture_rect(texture, rect, false)
		else:
			# Fallback to solid color if texture not found
			draw_rect(rect, snake_body_color)
	else:
		# Use solid color
		draw_rect(rect, snake_body_color)

func _on_grid_updated():
	"""Called when grid needs to be redrawn"""
	queue_redraw()
