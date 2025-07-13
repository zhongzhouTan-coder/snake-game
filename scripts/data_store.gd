extends Node

class_name DataStore

static var instance: DataStore

var player_score: float = 0.0
var player_speed: float = 0.0

signal player_score_update(data: float)
signal player_speed_update(data: float)

func _ready() -> void:
	instance = self

func get_player_score() -> float:
	return instance.player_score

func increase_player_score(score: float):
	instance.player_score += score
	player_score_update.emit(get_player_score())

func update_player_speed(speed: float):
	instance.player_speed = speed
	player_speed_update.emit(speed)
