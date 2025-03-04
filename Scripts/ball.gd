extends RigidBody2D
@onready var kick_sound = $"../Sounds/kick_sound"

var last_touched = "L"


func _ready():

	add_to_group("Balls")
	linear_velocity += Vector2(randf_range(-100, 100), randfn(-20, 20))

	
func slow():
	linear_velocity *= 0.3


func _on_body_entered(body: Node) -> void:
	kick_sound.play()
	if body.is_in_group("PlayerLeft"):
		last_touched = "L"
	elif body.is_in_group("PlayerRight"):
		last_touched = "R"
