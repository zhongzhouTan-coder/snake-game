extends Node2D

class_name Food

@export var food_value: int = 10

@onready var area: Area2D = $Area2D


signal detect_body_enter(food: Food)

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node2D):
	detect_body_enter.emit(self)
	area.set_deferred("monitoring", false)
