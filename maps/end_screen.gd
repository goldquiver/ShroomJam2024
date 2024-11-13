extends Node2D

@onready var splash = $Splash
@onready var timer = $Timer

var random_arr = [
	"base", "base", "base", "base", 
	"blink-glorbo", 
	"blink-shroomy", 
	"glitch-1", "glitch-1", "glitch-1", "glitch-1", 
	"glitch-2", "glitch-2", "glitch-2", "glitch-2", 
	"glitch-3", "glitch-3", "glitch-3", "glitch-3"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	splash.play("base")
	var root = State.get_node_in_group("root")
	root.play_music_credits()


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var root = State.get_node_in_group("root")
		root.change_map("res://maps/credits_screen.tscn")


func _on_timer_timeout():
	timer.wait_time += 0.02
	var anim_name = random_arr.pick_random()
	splash.play(anim_name)
