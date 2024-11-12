extends Node2D

@onready var anim_player = $AnimationPlayer
@onready var camera = $Camera2D
@onready var curr_camera_target

@export_range (0, 1) var camera_smoothing: float = 0.06

var glitch_ratio = 0.01

func _ready():
	$Door.open_door()
	check_glorbo_cutscene()


func check_glorbo_cutscene():
	var root = State.get_node_in_group("root")
	var seen_cutscene = root.get_trigger_data("seen_glorbo_cutscene_glitch")
	
	if not seen_cutscene:
		curr_camera_target = $Glorbo
		anim_player.play("init")
	else:
		curr_camera_target = $Shroomy


func _process(_delta):
	$"background/bg-glitched".visible = randf() < glitch_ratio
	$"background/bg-glitched".modulate.a = randf()
	
	if curr_camera_target:
		camera.position.x += (curr_camera_target.position.x - camera.position.x) * camera_smoothing
		camera.position.y += (curr_camera_target.position.y - camera.position.y) * camera_smoothing


func set_glitch_ratio(new_val: float):
	glitch_ratio = new_val


func triggered(trigger_name: String):	
	if trigger_name == "trg_floor1":
		var floor1 = $walldecor/CollapsedFloor1
		floor1.visible = true
		var coll = floor1.find_child("StaticBody2D") as StaticBody2D
		coll.set_collision_layer_value(1, true)
		coll.set_collision_mask_value(1, true)
		$Triggers/trg_floor1.queue_free()
		
	if trigger_name == "trg_floor2":
		var floor2 = $walldecor/CollapsedFloor2
		floor2.visible = true
		var coll = floor2.find_child("StaticBody2D") as StaticBody2D
		coll.set_collision_layer_value(1, true)
		coll.set_collision_mask_value(1, true)
		$Triggers/trg_floor2.queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "init":
		var root = State.get_node_in_group("root")
		root.set_trigger_data("seen_glorbo_cutscene_glitch", true)
		curr_camera_target = State.get_node_in_group("player")
