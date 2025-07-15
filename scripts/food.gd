extends Node2D

class_name Food

@export var food_type: FoodType = FoodType.APPLE
@export var value: float = 10.0

@onready var area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D

var fruit_atlas: Texture2D = preload("res://assets/textures/snake_game.png")

signal detect_body_enter(food: Food)

enum FoodType {
	APPLE,
	ORANGE,
	BANANA,
	GRAPE,
}

var fruit_regions = {
	FoodType.APPLE: Rect2(0, 48, 16, 16),
	FoodType.ORANGE: Rect2(16, 48, 16, 16),
	FoodType.BANANA: Rect2(48, 32, 16, 16),
	FoodType.GRAPE: Rect2(48, 48, 16, 16)
}

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	setup_sprite()

func setup_sprite():
	if fruit_atlas and fruit_regions.has(food_type):
		var atlas_texture = AtlasTexture.new()
		atlas_texture.atlas = fruit_atlas
		atlas_texture.region = fruit_regions[food_type]
		sprite.texture = atlas_texture

func initialize(type: FoodType):
	food_type = type

func _on_body_entered(_body: Node2D):
	detect_body_enter.emit(self)
	area.set_deferred("monitoring", false)

func get_score() -> float:
	return self.value
