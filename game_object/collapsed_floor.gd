extends Node2D

@onready var audio_stream_player_2d = $AudioStreamPlayer2D


func play_sound():
	audio_stream_player_2d.play()
