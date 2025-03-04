extends Node

var score_left = 0
var score_right = 0
var game_time: float = 91.0
var ambience_sound_pos = 0
var audio_stream_player = AudioStreamPlayer.new()
const WAFFLES = preload("res://Art/sounds/waffles.wav")
const AMBIENCE = preload("res://Art/sounds/aimbience.wav")
var selected_player_left
var selected_player_right

func _ready():
	add_child(audio_stream_player)
	audio_stream_player.stream = WAFFLES
	audio_stream_player.process_mode = Node.PROCESS_MODE_ALWAYS
	audio_stream_player.autoplay = true
	audio_stream_player.play()

func waffles():
	if audio_stream_player.stream == AMBIENCE:
		audio_stream_player.stop()
		audio_stream_player.stream = WAFFLES
		audio_stream_player.play()
func ambience():
	if audio_stream_player.stream == WAFFLES:
		var tween = get_tree().create_tween()
		tween.tween_property(audio_stream_player, "volume_db", -40, 3.0) 
		await tween.finished 
		audio_stream_player.stop()
		audio_stream_player.stream = AMBIENCE
		audio_stream_player.play()
		audio_stream_player.volume_db = -40
		tween = get_tree().create_tween()
		tween.tween_property(audio_stream_player, "volume_db", 0, 3.0) 
