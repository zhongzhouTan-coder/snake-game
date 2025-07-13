extends Control

class_name ScoreBoard

@onready var score_label: Label = $ScoreContainer/ScoreLabel
@onready var speed_label: Label = $ScoreContainer/SpeedLabel

func _ready() -> void:
	update_score(0.0)
	update_speed(0.0)

func update_score(value: float):
	score_label.text = "Score: %d" % value

func update_speed(value: float):
	speed_label.text = "Speed: %d" % value
