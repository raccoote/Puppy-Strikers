extends Control
@onready var button_play: AnimatedSprite2D = $TwoPlayer2/buttonPlay

func start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/startscreen.tscn")


func start_button_up() -> void:
	button_play.frame = 0


func _on_two_player_2_button_down() -> void:
	button_play.frame = 1
