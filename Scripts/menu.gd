extends Control

@onready var left_player_select: AnimatedSprite2D = $LeftPlayerSelect
@onready var right_player_select: AnimatedSprite2D = $RightPlayerSelect
@onready var animated_sprite_2d: AnimatedSprite2D = $TwoPlayer/AnimatedSprite2D


var left_index = 2
var right_index = 4

func _on_two_player_pressed():
	Global.selected_player_left = left_index
	Global.selected_player_right = right_index
	get_tree().change_scene_to_file("res://Scenes/hammerball.tscn")


func _on_button_left_back_pressed() -> void:
	left_index -= 1
	if left_index < 0: left_index = 5
	
	left_player_select.frame = left_index


func _on_button_left_forward_pressed() -> void:
	left_index += 1
	if left_index > 5: left_index = 0
	
	left_player_select.frame = left_index


func _on_button_right_back_pressed() -> void:
	right_index -= 1
	if right_index < 0: right_index = 5
	
	right_player_select.frame = right_index


func _on_button_right_forward_pressed() -> void:
	right_index += 1
	if right_index > 5: right_index = 0
	
	right_player_select.frame = right_index


func _on_two_player_button_up() -> void:
	animated_sprite_2d.frame = 0


func _on_two_player_button_down() -> void:
	animated_sprite_2d.frame = 1
