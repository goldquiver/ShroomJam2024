extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var camera = $Camera2D

@export_range (0, 1) var camera_smoothing: float = 0.06


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("intro")


func _process(_delta):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var target_position_x = player.position.x
		camera.position.x += (target_position_x - camera.position.x) * camera_smoothing
		var target_position_y = player.position.y
		camera.position.y += (target_position_y - camera.position.y) * camera_smoothing
