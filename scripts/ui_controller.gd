extends Control

class_name UIController

@onready var score_board: ScoreBoard = $ScoreBoard

func _ready() -> void:
	GameData.player_score_update.connect(_on_player_score_update)
	GameData.player_speed_update.connect(_on_player_speed_update)
	
func _on_player_score_update(value: float):
	score_board.update_score(value)

func _on_player_speed_update(value: float):
	score_board.update_speed(value)
