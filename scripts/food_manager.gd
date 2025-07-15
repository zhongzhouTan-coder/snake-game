extends Node2D

class_name FoodManager

@export var food_scene: PackedScene = preload("res://scenes/food.tscn")

var food_instance: Food = null
var food_types: Array[Food.FoodType] = [
	Food.FoodType.APPLE,
	Food.FoodType.BANANA,
	Food.FoodType.ORANGE,
	Food.FoodType.GRAPE,
]

var position_generator: Callable

signal food_eaten(value: float)

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
	food_instance.initialize(food_types[randi_range(0, food_types.size() - 1)])
	food_instance.detect_body_enter.connect(_on_food_eaten)
	var pos = position_generator.call()
	food_instance.global_position = pos
	add_child(food_instance)
	print("Food spawned at position: ", pos)

func _on_food_eaten(food_node: Food):
	print("Food eaten! Value: ", food_node.value)
	food_eaten.emit(food_node.value)
