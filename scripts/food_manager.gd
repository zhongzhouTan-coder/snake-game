extends Node2D

class_name FoodManager

@export var food_scene: PackedScene = preload("res://scenes/food.tscn")

var food_instance: Food = null

var position_generator: Callable

signal food_eaten(food_value: int)

func initialize(generator: Callable):
	position_generator = generator
	spawn_food()

func _ready() -> void:
	print("FoodManager is ready")

func free_food():
	if is_instance_valid(food_instance):
		food_instance.queue_free()
		food_instance = null

func spawn_food():
	if not position_generator.is_valid():
		print("Error: Position generator not set!")
		return

	food_instance = food_scene.instantiate()
	food_instance.detect_body_enter.connect(_on_food_eaten)
	var pos = position_generator.call()
	food_instance.global_position = pos
	add_child(food_instance)
	print("Food spawned at position: ", pos)

func _on_food_eaten(food_node: Food):
	print("Food eaten! Value: ", food_node.food_value)
	food_eaten.emit(food_node.food_value)
	free_food()
	spawn_food()
