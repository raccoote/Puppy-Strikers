extends Control
@onready var button_play: AnimatedSprite2D = $TwoPlayer2/buttonPlay
@onready var button_guide: AnimatedSprite2D = $HowToPlay/buttonGuide

func _ready() -> void:
	var global_script = get_node("/root/Global")
	global_script.waffles()
	if button_play:
		button_play.frame = 0 
	if button_guide:
		button_guide.frame = 0


func start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func start_button_up() -> void:
	button_play.frame = 0


func _on_two_player_2_button_down() -> void:
	button_play.frame = 1


func _on_how_to_play_button_down() -> void:
	button_guide.frame = 1


func _on_how_to_play_button_up() -> void:
	button_guide.frame = 0


func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/guide.tscn")
