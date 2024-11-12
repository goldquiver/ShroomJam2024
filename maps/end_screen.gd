extends Node2D

@onready var splash = $Splash
@onready var glitch = $Glitch

@onready var audio_stream_player_2d = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	splash.play("base")


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var root = State.get_node_in_group("root")
		root.change_map("res://maps/credits_screen.tscn")


func _on_audio_stream_player_2d_finished():
	audio_stream_player_2d.play()
