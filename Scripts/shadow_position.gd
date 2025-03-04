extends Sprite2D
@onready var ball = $"../Ball"




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = ball.position.x
