extends Area2D

@onready var player_right = $"../PlayerRight"
@onready var player_left = $"../PlayerLeft"
@onready var animated_sprite_2d = $aniamtedSprite2D
@onready var powerup_sound = $"../Sounds/powerup_collected"


const BALL = preload("res://Scenes/ball.tscn")

const POWER_UP_DURATION = 10

enum PowerUpType { BIG_BALL, DOUBLE_BALL, CRAZY_BALL, SQUARE_BALL, LOW_GRAVITY,
 SPEED, JUMP_BOOST, INCREACE_TIME, REDUCE_TIME }

var type: PowerUpType
var player
var ball

var acctive_effect
var effect_time_left

func _ready():
	match type:
		PowerUpType.BIG_BALL:
			animated_sprite_2d.play("big")
		PowerUpType.DOUBLE_BALL:
			animated_sprite_2d.play("double")
		PowerUpType.CRAZY_BALL:
			animated_sprite_2d.play("crazy")
		PowerUpType.SQUARE_BALL:
			animated_sprite_2d.play("square")
		PowerUpType.LOW_GRAVITY:
			animated_sprite_2d.play("low")
		PowerUpType.SPEED:
			animated_sprite_2d.play("speed")
		PowerUpType.JUMP_BOOST:
			animated_sprite_2d.play("jump")
		PowerUpType.INCREACE_TIME:
			animated_sprite_2d.play("increase")
		PowerUpType.REDUCE_TIME:
			animated_sprite_2d.play("reduce")
			
	
	
func power_up_collected(body):
	powerup_sound.play()
	ball = body
	
	if ball.last_touched == "L":
		player = player_left
	elif ball.last_touched == "R":
		player = player_right
		
	match type:
		PowerUpType.BIG_BALL:
			for b in get_tree().get_nodes_in_group("Balls"):
				var big_ball = CircleShape2D.new()
				big_ball.radius = 32
				b.get_node("CollisionShape2D").set_deferred("shape", big_ball)
				var animated_sprite = b.get_node("AnimatedSprite2D")  # Adjust path if necessary
				if animated_sprite:
					animated_sprite.scale = Vector2(1.1, 1.1)
		PowerUpType.DOUBLE_BALL:
			var new_ball = BALL.instantiate()
			new_ball.add_to_group("Balls")
			new_ball.position = ball.position
			new_ball.linear_velocity = ball.linear_velocity / 1.2
			get_parent().call_deferred("add_child", new_ball)
		PowerUpType.CRAZY_BALL:
			for b in get_tree().get_nodes_in_group("Balls"):
				var crazy_ball = CircleShape2D.new()
				crazy_ball.radius = 12
				b.get_node("CollisionShape2D").set_deferred("shape", crazy_ball)
				b.physics_material_override.set_bounce(0.8)
				var animated_sprite = b.get_node("AnimatedSprite2D")
				if animated_sprite:
					animated_sprite.play("crazy")
					animated_sprite.scale = Vector2(0.4, 0.4)
		PowerUpType.SQUARE_BALL:
			for b in get_tree().get_nodes_in_group("Balls"):
				var rect = RectangleShape2D.new()
				rect.extents = Vector2(15, 15)
				b.get_node("CollisionShape2D").set_deferred("shape", rect)
				var animated_sprite = b.get_node("AnimatedSprite2D")
				if animated_sprite:
					animated_sprite.play("square")
		PowerUpType.LOW_GRAVITY:
			for b in get_tree().get_nodes_in_group("Balls"):
				b.gravity_scale = 0.3
				b.mass = 0.5
		PowerUpType.SPEED:
			player.speed = 500.0
		PowerUpType.JUMP_BOOST:
			player.jump_impulse = 1200.0
		PowerUpType.INCREACE_TIME:
			Global.game_time += 15
		PowerUpType.REDUCE_TIME:
			if Global.game_time<15:
				Global.game_time=0
			else:
				Global.game_time -= 15

			
	var timer = Timer.new()
	timer.wait_time = POWER_UP_DURATION
	timer.one_shot = true
	timer.timeout.connect(_on_power_up_timeout)
	add_child(timer)
	timer.start()
	set_deferred("monitoring", false)
	visible = false

func _on_power_up_timeout():
	
	match type:
		PowerUpType.BIG_BALL:
			# var normal_ball = CircleShape2D.new()
			# normal_ball.radius = 16
			# ball.get_node("CollisionShape2D").shape = normal_ball
			pass
		PowerUpType.DOUBLE_BALL:
			pass
		PowerUpType.CRAZY_BALL:
			# ball.get_node("CollisionShape2D").scale *= 2
			# ball.physics_material_override.set_bounce(0.55)
			pass
		PowerUpType.SQUARE_BALL:
			# var circle = CircleShape2D.new()
			# circle.radius = 16
			# ball.get_node("CollisionShape2D").shape = circle
			#var animated_sprite = b.get_node("AnimatedSprite2D")
			#	if animated_sprite:
			#		animated_sprite.play("default")
			pass
		PowerUpType.LOW_GRAVITY:
			for b in get_tree().get_nodes_in_group("Balls"):
				b.gravity_scale = 1
				b.mass = 0.33
		PowerUpType.SPEED:
			player.speed = 300.0
		PowerUpType.JUMP_BOOST:
			player.jump_impulse = 1000.0



func _on_body_entered(body):
	if body.is_in_group("Balls"):
		power_up_collected(body)
		
