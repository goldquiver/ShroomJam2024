extends Node2D

@onready var camera = $Camera2D
@onready var animation_player = $AnimationPlayer
@onready var rooftop_base_1 = $background/rooftop_base_1
@onready var timer = $Timer

@export_range (0, 1) var camera_smoothing: float = 0.06

var anim_pool = [
	"default", "base-1", "base-2", "base-3", "base-4", "base-5"
]


func _ready():
	animation_player.play("Ending01")


func _process(_delta):
	var target = get_tree().get_first_node_in_group("player")
	if target:
		camera.position.x += (target.position.x - camera.position.x) * camera_smoothing
		camera.position.y += (target.position.y - camera.position.y) * camera_smoothing


func triggered(trigger_name: String):
	print(trigger_name)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Ending01":
		var root = State.get_node_in_group("root")
		root.change_map("res://maps/end_screen.tscn")


func _on_timer_timeout():
	timer.wait_time = randf_range(0.25, 0.75)
	var next_anim = anim_pool.pick_random()
	rooftop_base_1.play(next_anim)
