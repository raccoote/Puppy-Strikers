extends Node2D

@onready var timer = $Goal2SecondTimer
@onready var game_timer = $GameTimer
@onready var collision_shape_rightgoal = $GoalRight/GoalArea/CollisionShape2D
@onready var collision_shape_leftgoal = $GoalLeft/GoalArea/CollisionShape2D
@onready var medal_right: Sprite2D = $PlayerRight/MedalRight
@onready var medal_left: Sprite2D = $PlayerLeft/MedalLeft

@onready var goal_sound = $Sounds/goal_sound
@onready var whistle_end = $Sounds/whistle_end
@onready var cheer_sound = $Sounds/cheer_sound
@onready var short_cheer_sound = $Sounds/short_cheer_sound

@onready var animated_sprite_left: AnimatedSprite2D = $PlayerLeft/AnimatedSprite2D
@onready var animated_sprite_right: AnimatedSprite2D = $PlayerRight/AnimatedSprite2D
@onready var label = $Scoreboard

@onready var animation_player: AnimationPlayer = $ColorRect/AnimationPlayer


var done_hard_reset = false

var power_ups = preload("res://Scenes/power_up.tscn")
enum PowerUpType { BIG_BALL, DOUBLE_BALL, CRAZY_BALL, SQUARE_BALL, LOW_GRAVITY,
 SPEED, JUMP_BOOST, INCREACE_TIME, REDUCE_TIME }




func _ready():
	label.text = str(Global.score_left) + " - " + str(Global.score_right)
	game_timer.text = "%02d:%02d" % [int(Global.game_time) / 60, int(Global.game_time) % 60]
	animated_sprite_left.frame = Global.selected_player_left
	animated_sprite_right.frame = Global.selected_player_right
	get_tree().paused = true
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = false
	var global_script = get_node("/root/Global")
	global_script.ambience()

	
func _process(delta):
	Global.game_time -= delta
	if Global.game_time > 0:
		game_timer.text = "%02d:%02d" % [int(Global.game_time) / 60, int(Global.game_time) % 60]
	else:
		game_timer.text = "00:00"
		if not done_hard_reset:
			hard_reset()
	if randf() > 0.998 and get_tree().get_nodes_in_group("Powerups").size() < 3:
		var power_up_instance = power_ups.instantiate()
		power_up_instance.type = PowerUpType.values().pick_random() 
		add_child(power_up_instance)
		power_up_instance.position = Vector2(randi_range(200, 1150), randi_range(200, 400)) 
		

	
func _on_goal_left_body_entered(body):
	if body.is_in_group("Balls"):
		goal_sound.play()
		short_cheer_sound.play()
		Global.score_right += 1
		label.text = str(Global.score_left) + " - " + str(Global.score_right)
		collision_shape_rightgoal.queue_free()
		collision_shape_leftgoal.queue_free()
		call_deferred("reset")

func _on_goal_right_body_entered(body):
	if body.is_in_group("Balls"):
		goal_sound.play()
		short_cheer_sound.play()
		Global.score_left += 1
		label.text = str(Global.score_left) + " - " + str(Global.score_right)
		collision_shape_rightgoal.queue_free()
		collision_shape_leftgoal.queue_free()
		call_deferred("reset")
		
func _on_goal_area_body_exited(body):
	if body.is_in_group("Balls"):
		body.slow()
		body.physics_material_override.set_bounce(0.6)

func reset():
	if Global.game_time > 4:
		timer.wait_time = 2  # 2 seconds after entering goal area
		timer.start()
		await timer.timeout
		get_tree().change_scene_to_file("res://Scenes/hammerball.tscn")

func hard_reset():
	done_hard_reset = true
	whistle_end.play()
	cheer_sound.play()
	timer.wait_time = 4  # end scene 4 seconds after timer reached 00:00
	if Global.score_right > Global.score_left:
		medal_right.visible = true
	elif Global.score_right == Global.score_left:
		medal_right.visible = true
		medal_left.visible = true
	else:
		medal_left.visible = true
	timer.start()
	await timer.timeout
	animation_player.play("close")
	timer.wait_time = 1
	timer.start()
	await timer.timeout
	Global.score_right = 0 
	Global.score_left = 0 
	Global.game_time = 91.0
	get_tree().change_scene_to_file("res://Scenes/startscreen.tscn")


func _on_over_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("Balls"):
		body.apply_central_impulse(Vector2(0, -400))
