extends Node2D

@onready var camera = $Camera2D
@onready var anim_player = $AnimationPlayer

@export_range (0, 1) var camera_smoothing: float = 0.06


func _ready():
	anim_player.play("init")
	$Door.open_door()


func _process(_delta):
	var target = get_tree().get_first_node_in_group("player")
	if target:
		camera.position.x += (target.position.x - camera.position.x) * camera_smoothing
		camera.position.y += (target.position.y - camera.position.y) * camera_smoothing


func triggered(trigger_name: String):
	var root = State.get_node_in_group("root")
	
	if trigger_name == "trg_make_glorbo_esped":
		root.set_trigger_data("can_pass_endless_hall", true)
		anim_player.play("glorbo_through_wall")
		$Triggers/trg_make_glorbo_esped.queue_free()
