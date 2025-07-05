extends Node2D

class_name FoodManager

@export var food_scene: PackedScene = preload("res://scenes/food.tscn")
@export var min_spawn_distance: int = 3;

var current_food: Food = null

signal food_eaten(food_value: int)
signal food_spawned(grid_position: Vector2)

func _ready() -> void:
	print("FoodManager is ready")


func spawn_food_at_grid_position(grid_pos: Vector2i, background: Background):
	"""在指定网格位置生成食物"""
	if current_food:
		current_food.queue_free()
		current_food = null
	
	# 创建食物实例
	current_food = food_scene.instantiate()
	current_food.detect_body_enter.connect(_on_food_eaten)
	
	# 设置世界坐标位置
	var world_pos = background.grid_to_world(grid_pos)
	current_food.global_position = world_pos
	
	# 添加到场景
	add_child(current_food)
	
	# 发出食物已生成信号
	food_spawned.emit(grid_pos)
	print("Food spawned at grid position: ", grid_pos)

func _on_food_eaten(food_node: Food):
	print("Food eaten! Value: ", food_node.food_value)
	food_eaten.emit(food_node.food_value)
