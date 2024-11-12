extends Node2D

@onready var splash = $Splash
@onready var glitch = $Glitch


# Called when the node enters the scene tree for the first time.
func _ready():
	splash.play("base")
	var root = State.get_node_in_group("root")
	root.play_music_credits()


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var root = State.get_node_in_group("root")
		root.change_map("res://maps/credits_screen.tscn")
