extends CharacterBody2D

class_name SnakeHead

# Movement properties
@export var move_speed: float = 200.0
@export var grid_size: int = 32 # Size of each grid cell
@export var smooth_movement: bool = true

# Direction vectors
var current_direction: Vector2 = Vector2.RIGHT
var next_direction: Vector2 = Vector2.RIGHT
var target_position: Vector2
var is_moving: bool = false

# Movement timing
var move_timer: Timer
@export var move_interval: float = 0.3 # Time between moves in grid mode

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Signals
signal hit_wall
signal hit_obstacle

func _ready():
	# Setup movement
	target_position = global_position
	setup_movement_timer()

func set_texture(texture: Texture2D):
	"""Set the sprite texture"""
	if sprite:
		sprite.texture = texture

func setup_movement_timer():
	"""Setup timer for grid-based movement"""
	move_timer = Timer.new()
	move_timer.wait_time = move_interval
	move_timer.timeout.connect(_on_move_timer_timeout)
	add_child(move_timer)
	
	if not smooth_movement:
		move_timer.start()

func _input(event):
	"""Handle input for direction changes"""
	var new_direction = Vector2.ZERO
	
	if event.is_action_pressed("ui_up"):
		new_direction = Vector2.UP
	elif event.is_action_pressed("ui_down"):
		new_direction = Vector2.DOWN
	elif event.is_action_pressed("ui_left"):
		new_direction = Vector2.LEFT
	elif event.is_action_pressed("ui_right"):
		new_direction = Vector2.RIGHT
	
	if new_direction != Vector2.ZERO:
		change_direction(new_direction)

func change_direction(new_direction: Vector2):
	"""Change snake direction, preventing reverse movement"""
	# Prevent moving in opposite direction
	if new_direction + current_direction != Vector2.ZERO:
		next_direction = new_direction
		
		# If using smooth movement, change direction immediately
		if smooth_movement:
			current_direction = next_direction

func _process(delta):
	"""Handle smooth movement"""
	if smooth_movement:
		move_smooth(delta)
	else:
		move_grid(delta)

func move_smooth(delta):
	"""Smooth continuous movement"""
	velocity = current_direction * move_speed
	
	# Use CharacterBody2D's built-in collision detection
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)

func move_grid(delta):
	"""Grid-based step movement with collision detection"""
	if is_moving:
		# Calculate movement direction
		var direction = (target_position - global_position).normalized()
		velocity = direction * move_speed
		
		# Move with collision detection
		var collision = move_and_collide(velocity * delta)
		if collision:
			handle_collision(collision)
			is_moving = false
			return
		
		# Check if reached target
		if global_position.distance_to(target_position) < 1.0:
			global_position = target_position
			is_moving = false

func _on_move_timer_timeout():
	"""Called when it's time to move to next grid position"""
	if not is_moving:
		# Update direction
		current_direction = next_direction
		
		# Calculate next position
		var next_pos = global_position + (current_direction * grid_size)
		target_position = next_pos
		is_moving = true

func set_movement_mode(smooth: bool):
	"""Switch between smooth and grid movement"""
	smooth_movement = smooth
	
	if smooth_movement:
		move_timer.stop()
		is_moving = false
		target_position = global_position
	else:
		# Snap to grid
		snap_to_grid()
		move_timer.start()

func snap_to_grid():
	"""Snap position to nearest grid point"""
	var grid_x = round(global_position.x / grid_size) * grid_size
	var grid_y = round(global_position.y / grid_size) * grid_size
	global_position = Vector2(grid_x, grid_y)
	target_position = global_position

func handle_collision(collision: KinematicCollision2D):
	"""Handle collision with walls or obstacles"""
	print("Snake hit something at: ", collision.get_position())
	
	# Stop movement
	velocity = Vector2.ZERO
	
	# Determine collision type based on collider
	var collider = collision.get_collider()
	if collider:
		# Check if it's a TileMapLayer (wall)
		if collider is TileMapLayer:
			print("Snake hit wall")
			hit_wall.emit()
		# Check if collider has a method to identify itself
		elif collider.has_method("is_wall"):
			hit_wall.emit()
		else:
			print("Snake hit obstacle")
			hit_obstacle.emit()
	else:
		# Default to wall collision
		hit_wall.emit()
	
	# Stop the snake
	current_direction = Vector2.ZERO
	next_direction = Vector2.ZERO
	is_moving = false
